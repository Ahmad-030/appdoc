import 'dart:convert';
import 'package:doctorappflutter/Auth/resetpassworddetails.dart';
import 'package:doctorappflutter/Auth/resetpasswordscreen.dart';
import 'package:doctorappflutter/apiconstants/apiconstantsurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:doctorappflutter/Model/Auth/authforgotresponse.dart';

class Forgotpasscontroller extends GetxController {
  var isLoading = false.obs;

  Future<void> userforgotpass(
      {required String useremail
      }
      ) async {
    if (useremail.isEmpty) {
      showToast("Please fill in all fields");
      return;
    }

    if (!useremail.contains("@gmail.com")) {
      showToast("Please enter a valid Gmail address");
      return;
    }

    isLoading.value = true; // Show loader before API call
    try {
      final response = await http.post(
        Uri.parse("${Apiconstantsurl.baseUrl}${Apiconstantsurl.forgotEndpoint}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": useremail,
        }),
      );

      final responseData = jsonDecode(response.body);
      // Map the response to the model
      Authforgotresponse authResponse = Authforgotresponse.fromJson(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showToast(authResponse.message);
        Get.to(Resetpasswordscreen(useremail: useremail));

      } else {
        showToast(authResponse.message ?? "Invalid email or password");
      }
    } catch (e) {
      showToast("Error: ${e.toString()}");
    } finally {
      isLoading.value = false; // Hide loader after API call
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
