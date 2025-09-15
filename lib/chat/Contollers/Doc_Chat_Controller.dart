import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../doctor side/ModelCLass.dart';

class DoctorChatController extends GetxController {
  var appointments = <PatientAppointment>[].obs;
  final String doctorId = "679370c7f8369e7ede89a572";

  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  @override
  void onInit() {
    super.onInit();
    listenToAppointments();
  }

  /// Send a new message
  Future<void> sendMessage(
      String appointmentId, String senderId, String text) async {
    final messageRef = _db.child("chats/$appointmentId/messages").push();

    await messageRef.set({
      "senderId": senderId,
      "text": text,
      "timestamp": DateTime.now().toIso8601String(),
      "seen": false,
    });

    // 🔹 Update appointment last message time
    updateLastMessageTime(appointmentId, DateTime.now());
  }

  /// Listen to messages in realtime
  Stream<DatabaseEvent> getMessagesStream(String appointmentId) {
    return _db.child("chats/$appointmentId/messages").onValue;
  }

  /// Mark patient messages as seen
  Future<void> markMessagesAsSeen(String appointmentId, String doctorId) async {
    final ref = _db.child("chats/$appointmentId/messages");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      for (var entry in data.entries) {
        final msg = Map<String, dynamic>.from(entry.value);
        if (msg["senderId"] != doctorId && msg["seen"] == false) {
          await ref.child(entry.key).update({"seen": true});
        }
      }
    }
  }

  /// Listen to doctor’s appointments in realtime
  void listenToAppointments() {
    _db.child("appointments").onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);

        final updated = data.entries.map((e) {
          final a = Map<String, dynamic>.from(e.value);
          return PatientAppointment(
            appointmentId: e.key,
            patientName: "${a['patientFirstName']} ${a['patientLastName']}",
            AppointmentId: e.key,
            lastMessageTime: DateTime.now().subtract(const Duration(days: 1)), // default
          );
        }).toList();

        appointments.assignAll(updated);
        sortAppointments();
      } else {
        appointments.clear();
      }
    });
  }

  /// 🔹 Update last message time and sort
  void updateLastMessageTime(String appointmentId, DateTime time) {
    final index = appointments.indexWhere((a) => a.appointmentId == appointmentId);
    if (index != -1) {
      appointments[index].lastMessageTime = time;
      sortAppointments();
    }
  }

  void sortAppointments() {
    appointments.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    appointments.refresh();
  }
}
