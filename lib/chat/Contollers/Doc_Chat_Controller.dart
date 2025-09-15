//final String doctorId = "679370c7f8369e7ede89a572";
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../doctor side/ModelCLass.dart';

class DoctorChatController extends GetxController {
  var appointments = <PatientAppointment>[].obs;
  final String doctorId =
      "679370c7f8369e7ede89a572"; // Replace with actual doctor ID

  final DatabaseReference _db = FirebaseDatabase.instance.ref(); // root ref

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
    });
  }

  /// Listen to messages in realtime
  Stream<DatabaseEvent> getMessagesStream(String appointmentId) {
    return _db.child("chats/$appointmentId/messages").onValue;
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
            AppointmentId:
                e.key, // using appointmentId if no separate patientId
          );
        }).toList();

        appointments.assignAll(updated);
      } else {
        appointments.clear();
      }
    });
  }
}
