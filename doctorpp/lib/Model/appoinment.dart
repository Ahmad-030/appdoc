class Appointment {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String appointmentType;
  final String appointmentDate;
  final String status;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;

  final String doctorFirstName;
  final String doctorLastName;
  final String doctorEmail;

  final String createdAt;
  final String updatedAt;

  Appointment({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.appointmentType,
    required this.appointmentDate,
    required this.status,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.doctorFirstName,
    required this.doctorLastName,
    required this.doctorEmail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'],
      firstName: json['patientFirstName'],
      lastName: json['patientLastName'],
      phone: json['phone'],
      address: json['address'],
      appointmentType: json['appointmentType'],
      appointmentDate: json['appointmentDate'],
      status: json['appointmentStatus'],
      startHour: json['startTime']['hour'],
      startMinute: json['startTime']['minute'],
      endHour: json['endTime']['hour'],
      endMinute: json['endTime']['minute'],
      doctorFirstName: json['userId']['firstName'],
      doctorLastName: json['userId']['lastName'],
      doctorEmail: json['userId']['email'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
