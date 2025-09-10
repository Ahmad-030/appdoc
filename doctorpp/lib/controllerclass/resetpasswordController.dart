import 'dart:convert';
import 'package:doctorappflutter/apiconstants/apiconstantsurl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Resetpasswordcontroller extends GetxController {
  var isLoading = false.obs; // Loading state

  // Method to reset password
  Future<void> resetPass({
    required String email,
    required String pass,
    required String conpass,
    required String otp,
    required VoidCallback onSuccess, // Callback for success
  }) async {
    // Validation before making API request
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Fluttertoast.showToast(msg: "Please enter a valid email address");
      return;
    }
    if (otp.isEmpty) {
      Fluttertoast.showToast(msg: "OTP cannot be empty");
      return;
    }
    if (pass.isEmpty || conpass.isEmpty) {
      Fluttertoast.showToast(msg: "Password fields cannot be empty");
      return;
    }
    if (pass != conpass) {
      Fluttertoast.showToast(msg: "Passwords do not match");
      return;
    }

    try {
      isLoading.value = true; // Show loading

      final response = await http.post(
        Uri.parse("${Apiconstantsurl.baseUrl}${Apiconstantsurl.resetpasswrod}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "otp": otp,
          "newPassword": pass,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData["status"] == "success") {
        Fluttertoast.showToast(msg: responseData["message"]);

        // Call the success callback to clear fields
        onSuccess();

        // Optionally navigate to the login screen after successful password reset
        // Get.offAll(SignInScreen());  // Uncomment if needed
      } else {
        Fluttertoast.showToast(msg: responseData["message"] ?? "Failed to reset password");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong. Please try again.");
      print('Error resetting password: $e');
    } finally {
      isLoading.value = false; // Hide loading
    }
  }
}