class PatientAppointment {
  final String appointmentId;
  final String patientName;
  final String AppointmentId; // can be appointmentId if no separate patient ID
  DateTime lastMessageTime;   // 🔹 New field

  PatientAppointment({
    required this.appointmentId,
    required this.patientName,
    required this.AppointmentId,
    required this.lastMessageTime,
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
