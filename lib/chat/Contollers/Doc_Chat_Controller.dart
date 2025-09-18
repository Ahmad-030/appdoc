import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../doctor side/ModelCLass.dart';

class DoctorChatController extends GetxController {
  var appointments = <PatientAppointment>[].obs;
  final String doctorId = "679370c7f8369e7ede89a572";
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  /// Track unread messages
  var unreadStatus = <String, bool>{}.obs;

  /// Track last message text
  var lastMessages = <String, ChatMessage>{}.obs;

  @override
  void onInit() {
    super.onInit();
    listenToAppointments();
  }

  // Send a new message
  Future<void> sendMessage(String appointmentId, String senderId, String text) async {
    final messageRef = _db.child("chats/$appointmentId/messages").push();
    final now = DateTime.now();

    await messageRef.set({
      "senderId": senderId,
      "text": text,
      "timestamp": now.toIso8601String(),
      "seen": false,
    });

    updateLastMessageTime(
      appointmentId,
      ChatMessage(senderId: senderId, text: text, timestamp: now),
    );
  }

  // Stream messages
  Stream<DatabaseEvent> getMessagesStream(String appointmentId) {
    return _db.child("chats/$appointmentId/messages").onValue;
  }

  // Mark messages as seen
  Future<void> markMessagesAsSeenOnOpen(String appointmentId) async {
    final ref = _db.child("chats/$appointmentId/messages");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      bool hasUnseen = false;

      for (var entry in data.entries) {
        final msg = Map<String, dynamic>.from(entry.value);
        if (msg["senderId"] != doctorId && msg["seen"] == false) {
          await ref.child(entry.key).update({"seen": true});
        }
        if (msg["senderId"] != doctorId && msg["seen"] == false) {
          hasUnseen = true;
        }
      }

      unreadStatus[appointmentId] = hasUnseen;
      unreadStatus.refresh();
    }
  }

  // Listen to appointments
  void listenToAppointments() {
    _db.child("appointments").onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);

        final updated = data.entries.map((e) {
          final a = Map<String, dynamic>.from(e.value);

          // ✅ skip chats deleted by doctor
          if (a["deletedByDoctor"] == true) {
            return null;
          }

          return PatientAppointment(
            appointmentId: e.key,
            patientName: "${a['patientFirstName']} ${a['patientLastName']}",
            AppointmentId: e.key,
            lastMessageTime: DateTime.fromMillisecondsSinceEpoch(0),
          );
        }).whereType<PatientAppointment>().toList();

        appointments.assignAll(updated);

        // Listen last message per appointment
        for (var appt in appointments) {
          _db
              .child("chats/${appt.appointmentId}/messages")
              .orderByChild("timestamp")
              .limitToLast(1)
              .onChildAdded
              .listen((msgEvent) {
            if (msgEvent.snapshot.value != null) {
              final msg = Map<String, dynamic>.from(msgEvent.snapshot.value as Map);
              final time = DateTime.tryParse(msg["timestamp"] ?? "");
              if (time != null) {
                updateLastMessageTime(
                  appt.appointmentId,
                  ChatMessage(
                    senderId: msg["senderId"],
                    text: msg["text"],
                    timestamp: time,
                  ),
                );

                unreadStatus[appt.appointmentId] =
                    msg["seen"] == false && msg["senderId"] != doctorId;
                unreadStatus.refresh();
              }
            }
          });
        }
      } else {
        appointments.clear();
      }
    });
  }

  // Update last message
  void updateLastMessageTime(String appointmentId, ChatMessage msg) {
    final index = appointments.indexWhere((a) => a.appointmentId == appointmentId);
    if (index != -1) {
      lastMessages[appointmentId] = msg;
      appointments[index].lastMessageTime = msg.timestamp;
      sortAppointments();
      lastMessages.refresh();
    }
  }

  void sortAppointments() {
    appointments.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    appointments.refresh();
  }

  // Delete chat (doctor side only)
  Future<void> deleteChat(String appointmentId) async {
    await _db.child("appointments/$appointmentId").update({
      "deletedByDoctor": true,   // 👈 just mark instead of removing chat
    });

    lastMessages.remove(appointmentId);
    unreadStatus.remove(appointmentId);
  }
}
