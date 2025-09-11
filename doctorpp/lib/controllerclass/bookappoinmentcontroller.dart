import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class BookAppointmentController extends GetxController {
  final isLoading = false.obs;
  final isAccepted = false.obs; // ✅ Track appointment acceptance
  final _box = GetStorage();

  Future<void> bookAppointment({
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
    required String appointmentDate,
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
    required String appointmentType,
  }) async {
    isLoading.value = true;
    String? token = _box.read("auth_token");

    final url = Uri.parse(
        "https://doctor-appointment-xi-azure.vercel.app/api/v1/appointments");

    final body = {
      "startTime": {"hour": startHour, "minute": startMinute},
      "endTime": {"hour": endHour, "minute": endMinute},
      "appointmentDate": appointmentDate,
      "address": address,
      "phone": phone,
      "patientFirstName": firstName,
      "patientLastName": lastName,
      "appointmentType": appointmentType,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // ✅ Check appointment status in response
        if (data["status"] == "accepted") {
          isAccepted.value = true;
        } else {
          isAccepted.value = false;
        }

        Get.snackbar(
          "Success",
          "Appointment Booked Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage =
            errorData["error"] ?? "Failed to book appointment";

        isAccepted.value = false; // keep as not accepted on error

        Get.snackbar(
          "Error",
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      isAccepted.value = false; // reset on failure

      Get.snackbar(
        "Error",
        "An error occurred",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      print("Exception: $e");
    }
  }
}
