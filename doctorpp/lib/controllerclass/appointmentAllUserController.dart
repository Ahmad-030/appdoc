import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Model/appoinment.dart';
import '../StorageServiceClass/storageservice.dart';

class Appointmentallusercontroller extends GetxController {
  final storage = StorageService();
  final appointments = <Appointment>[].obs;
  var isLoading = true.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    fetchAllAppointments();

    // 🔄 Refresh every 15 seconds
    _timer = Timer.periodic(const Duration(seconds: 15), (_) {
      fetchAllAppointments();
    });
  }

  void fetchAllAppointments() async {
    final token = storage.readToken();
    if (token == null) {
      isLoading.value = false;
      Get.snackbar("Error", "User is not logged in.");
      return;
    }

    final url = Uri.parse(
        'https://doctor-appointment-xi-azure.vercel.app/api/v1/appointments');

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
        Get.snackbar("Error",
            "Failed to fetch appointments: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
