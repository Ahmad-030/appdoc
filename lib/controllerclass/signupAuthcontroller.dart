import 'dart:convert';
import 'package:doctorappflutter/Auth/authsigninscreen.dart';
import 'package:doctorappflutter/apiconstants/apiconstantsurl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Signupauthcontroller extends GetxController {
  var isLoading = false.obs;

  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    // Input Validations
    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      showToast("Please fill in all fields");
      return;
    }

    if (!RegExp(r"^[a-zA-Z]+$").hasMatch(firstName) || !RegExp(r"^[a-zA-Z]+$").hasMatch(lastName)) {
      showToast("First and Last Name should contain only letters");
      return;
    }

    if (!email.contains("@gmail.com")) {
      showToast("Please enter a valid Gmail address");
      return;
    }

    if (!RegExp(r"^[0-9]{10}$").hasMatch(phone)) {
      showToast("Phone number must be exactly 10 digits");
      return;
    }

    if (password.length < 8) {
      showToast("Password must be at least 8 characters long");
      return;
    }

    isLoading.value = true; // Show loader in button
    try {
      final response = await http.post(
        Uri.parse("${Apiconstantsurl.baseUrl}${Apiconstantsurl.registerEndpoint}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "phone": phone,
          "password": password,
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        showToast(responseData['message'] ?? "registered successfully", backgroundColor: Colors.blue);
         // Navigate to Home
        Get.to(Authsigninscreen());
      } else {
        showToast(responseData['message'] ?? "Something went wrong");
      }
    } catch (e) {
      showToast("Error: ${e.toString()}");
    } finally {
      isLoading.value = false; // Hide loader
    }
  }

  void showToast(String message, {Color backgroundColor = Colors.blue}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 14.0,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
