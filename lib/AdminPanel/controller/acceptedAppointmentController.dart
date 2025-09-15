import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

import '../../Model/appoinment.dart';
import '../../StorageServiceClass/storageservice.dart';

class AcceptedAppointmentController extends GetxController {
  var appointments = <Appointment>[].obs;
  var isLoading = true.obs;
  var isAccepted = false.obs;
  final storage = StorageService();
  Timer? _timer;

  // ✅ Firebase reference
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  @override
  void onInit() {
    super.onInit();
    fetchAcceptedAppointments();

    // 🔄 Refresh data every 15 seconds
    _timer = Timer.periodic(const Duration(seconds:20), (_) {
      fetchAcceptedAppointments();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void fetchAcceptedAppointments() async {
    isLoading.value = true;
    final token = storage.readToken();

    if (token == null) {
      isLoading.value = false;
      Get.snackbar("Error", "User is not logged in.");
      return;
    }

    final url = Uri.parse(
      'https://doctor-appointment-xi-azure.vercel.app/api/v1/appointments?status=Accepted',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;

        // 🔥 Sort latest on top
        final sorted = data.map((e) => Appointment.fromJson(e)).toList()
          ..sort((a, b) {
            final dateA = DateTime.parse(a.appointmentDate)
                .add(Duration(hours: a.startHour, minutes: a.startMinute));
            final dateB = DateTime.parse(b.appointmentDate)
                .add(Duration(hours: b.startHour, minutes: b.startMinute));
            return dateA.compareTo(dateB);
          });

        appointments.value = sorted;
        isAccepted.value = appointments.isNotEmpty;

        // ✅ Sync to Firebase
        for (var appointment in sorted) {
          await dbRef
              .child("appointments")
              .child(appointment.id)
              .set({
            "appointmentId": appointment.id,
            "patientFirstName": appointment.firstName,
            "patientLastName": appointment.lastName,
            "phone": appointment.phone,
            "address": appointment.address,
            "appointmentType": appointment.appointmentType,
            "appointmentDate": appointment.appointmentDate,
            "startHour": appointment.startHour,
            "startMinute": appointment.startMinute,
            "endHour": appointment.endHour,
            "endMinute": appointment.endMinute,
            "status": appointment.status,
            "doctorFirstName": appointment.doctorFirstName,
            "doctorLastName": appointment.doctorLastName,
            "doctorEmail": appointment.doctorEmail,
            "createdAt": appointment.createdAt,
            "updatedAt": appointment.updatedAt,
            "syncedAt": DateTime.now().toIso8601String(), // extra tracking
          }).then((_) {
            print("✅ Synced appointment ${appointment.id} to Firebase");
          });
        }

      } else {
        isAccepted.value = false;
        Get.snackbar(
          "Error",
          "Failed to fetch accepted appointments: ${response.statusCode}",
        );
      }
    } catch (e) {
      isAccepted.value = false;
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
