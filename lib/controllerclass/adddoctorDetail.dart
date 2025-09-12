import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../apiconstants/apiconstantsurl.dart';

class AddDoctorDetails extends GetxController {
  final _box = GetStorage();
  var isloading = false.obs;

  Future<void> addDetails({
    required String clinicAddress,
    required String clinicPhone,
    required String specialization,
    required String bio,
    required List<Map<String, dynamic>> workingDays,
  }) async {
    try {
      isloading.value = true;
      String? token = _box.read("auth_token");

      final body = {
        "clinicAddress": clinicAddress,
        "clinicPhone": clinicPhone,
        "specialization": specialization,
        "bio": bio,
        "workingDays": workingDays,
      };

      final response = await http.put(
        Uri.parse("${Apiconstantsurl.baseUrl}${Apiconstantsurl.getdoctordetails}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      isloading.value = false;

      if (response.statusCode == 200) {
        print("Doctor details updated successfully!");
        // Show success toast/snackbar
      } else {
        print("Error: ${response.statusCode}");
        print(response.body);
        // Show error toast/snackbar
      }
    } catch (e) {
      isloading.value = false;
      print("Exception occurred: $e");
    }
  }
}
