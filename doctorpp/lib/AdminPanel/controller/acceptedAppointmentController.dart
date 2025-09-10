import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Model/appoinment.dart';
import '../../StorageServiceClass/storageservice.dart';

class AcceptedAppointmentController extends GetxController {
  var appointments = <Appointment>[].obs;
  var isLoading = true.obs;
  final storage = StorageService();
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    fetchAcceptedAppointments();

    // 🔄 Refresh data every 15 seconds
    _timer = Timer.periodic(const Duration(seconds: 15), (_) {
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

            return dateA.compareTo(dateB); // nearest upcoming first
          });

        appointments.value = sorted;

        appointments.value = sorted;
      } else {
        Get.snackbar("Error",
            "Failed to fetch accepted appointments: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
