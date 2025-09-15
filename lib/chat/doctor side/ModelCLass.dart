// models.dart
class PatientAppointment {
  final String appointmentId;
  final String patientName;
  final String AppointmentId; // can be appointmentId if no separate patient ID

  PatientAppointment({
    required this.appointmentId,
    required this.patientName,
    required this.AppointmentId,
  });
}

class ChatMessage {
  final String senderId;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.senderId,
    required this.text,
    required this.timestamp,
  });
}
