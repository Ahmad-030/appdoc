class DoctorDetailsResponse {
  final String status;
  final String message;
  final DoctorDetails doctorDetails;

  DoctorDetailsResponse({
    required this.status,
    required this.message,
    required this.doctorDetails,
  });

  factory DoctorDetailsResponse.fromJson(Map<String, dynamic> json) {
    return DoctorDetailsResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      doctorDetails: DoctorDetails.fromJson(json['doctorDetails']),
    );
  }
}

class DoctorDetails {
  final String id;
  final Time startTime;
  final Time endTime;
  final String clinicAddress;
  final String clinicPhone;
  final String clinicEmail;
  final String doctorId;
  final String specialization;
  final String bio;
  final List<WorkingDay> workingDays;

  DoctorDetails({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.clinicAddress,
    required this.clinicPhone,
    required this.clinicEmail,
    required this.doctorId,
    required this.specialization,
    required this.bio,
    required this.workingDays,
  });

  factory DoctorDetails.fromJson(Map<String, dynamic> json) {
    return DoctorDetails(
      id: json['_id'] ?? '',
      startTime: Time.fromJson(json['startTime']),
      endTime: Time.fromJson(json['endTime']),
      clinicAddress: json['clinicAddress'] ?? '',
      clinicPhone: json['clinicPhone'] ?? '',
      clinicEmail: json['clinicEmail'] ?? '',
      doctorId: json['doctorId'] ?? '',
      specialization: json['specialization'] ?? '',
      bio: json['bio'] ?? '',
      workingDays: (json['workingDays'] as List<dynamic>)
          .map((e) => WorkingDay.fromJson(e))
          .toList(),
    );
  }
}

class Time {
  final int hour;
  final int minute;

  Time({required this.hour, required this.minute});

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      hour: json['hour'] ?? 0,
      minute: json['minute'] ?? 0,
    );
  }

  String get formattedTime {
    final h = hour > 12 ? hour - 12 : hour;
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m $suffix';
  }
}

class WorkingDay {
  final String day;
  final Time startTime;
  final Time endTime;
  final List<AppointmentSlot> appointSlots;

  WorkingDay({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.appointSlots,
  });

  factory WorkingDay.fromJson(Map<String, dynamic> json) {
    return WorkingDay(
      day: json['day'] ?? '',
      startTime: Time.fromJson(json['startTime']),
      endTime: Time.fromJson(json['endTime']),
      appointSlots: (json['appointSlots'] as List<dynamic>)
          .map((e) => AppointmentSlot.fromJson(e))
          .toList(),
    );
  }
}

class AppointmentSlot {
  final String id;
  final Time startTime;
  final Time endTime;

  AppointmentSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  factory AppointmentSlot.fromJson(Map<String, dynamic> json) {
    return AppointmentSlot(
      id: json['_id'] ?? '',
      startTime: Time.fromJson(json['startTime']),
      endTime: Time.fromJson(json['endTime']),
    );
  }
}
