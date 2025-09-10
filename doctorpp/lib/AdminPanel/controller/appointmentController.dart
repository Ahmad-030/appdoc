import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Model/appoinment.dart';
import '../../StorageServiceClass/storageservice.dart';

class AppointmentController extends GetxController {
  var appointments = <Appointment>[].obs;
  var isLoading = false.obs;
  var isUpdating = false.obs;

  final storage = StorageService();
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    fetchAppointmentsByStatus("Pending");

    // 🔄 Auto-refresh every 15 seconds
    _timer = Timer.periodic(const Duration(seconds: 15), (_) {
      fetchAppointmentsByStatus("Pending");
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  /// Fetch appointments by status
  Future<void> fetchAppointmentsByStatus(String status) async {
    final token = storage.readToken();

    if (token == null) {
      Get.snackbar("Error", "User is not logged in.");
      return;
    }

    final url = Uri.parse(
      'https://doctor-appointment-xi-azure.vercel.app/api/v1/appointments?status=$status',
    );

    try {
      isLoading.value = true;

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> appointmentsData = data['data'];

        appointments.value =
            appointmentsData.map((e) => Appointment.fromJson(e)).toList();
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch $status appointments: ${response.statusCode}",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Update appointment status
  Future<void> updateAppointmentStatus(
      String appointmentId, String status) async {
    final token = storage.readToken();

    if (token == null) {
      Get.snackbar("Error", "No token found. Please log in.");
      return;
    }

    final url = Uri.parse(
      'https://doctor-appointment-xi-azure.vercel.app/api/v1/appointments/update-status/$appointmentId',
    );

    try {
      isUpdating.value = true;

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"status": status}),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Appointment marked as $status");

        /// 🚀 Immediately refresh list (no need to wait 15s)
        fetchAppointmentsByStatus("Pending");
      } else {
        Get.snackbar(
            "Failed", "Failed to update status: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Error updating appointment: $e");
    } finally {
      isUpdating.value = false;
    }
  }
}
