import 'dart:convert';
import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/adminnavbottom.dart';
import 'package:doctorappflutter/DashboardScreen/userbottomnav.dart';
import 'package:doctorappflutter/StorageServiceClass/storageservice.dart';
import 'package:doctorappflutter/apiconstants/apiconstantsurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Signinauthcontroller extends GetxController {
  var isloading = false.obs;

  Future<void> signinuser({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      showToast("Please fill in all fields");
      return;
    }

    if (!email.contains("@gmail.com")) {
      showToast("Please enter a valid Gmail address");
      return;
    }

    if (password.length < 8) {
      showToast("Password must be at least 8 characters long");
      return;
    }

    isloading.value = true;

    try {
      final response = await http.post(
        Uri.parse("${Apiconstantsurl.baseUrl}${Apiconstantsurl.loginEndpoint}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showToast(responseData['message'] ?? "Login successful");

        String? token = responseData['token'];
        String? role = responseData['user']?['role'];

        if (token != null && role != null) {
          await StorageService().writeTokenAndRole(token, role);

          if (role.toLowerCase() == "doctor") {
            Get.offAll(() => Adminnavbottom());
          } else if (role.toLowerCase() == "patient") {
            Get.offAll(() => Userbottomnav());
          } else {
            showToast("Unknown role: $role");
          }
        } else {
          showToast("Login response missing token or role");
        }
      } else {
        showToast(responseData['message'] ?? "Invalid email or password");
      }
    } catch (e) {
      showToast("Error: ${e.toString()}");
    } finally {
      isloading.value = false;
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
