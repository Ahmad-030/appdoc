import 'dart:convert';
import 'dart:io';
import 'package:doctorappflutter/apiconstants/apiconstantsurl.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class Getcurrentuserprofile extends GetxController {
  final _box = GetStorage();

  var isLoading = true.obs;
  var photo = "".obs;
  var phone = "".obs;
  var firstName = "".obs;
  var lastName = "".obs;
  var address = "".obs;
  var isChanged = false.obs;

  Future<void> getProfileData() async {
    try {
      isLoading.value = true;
      String? token = _box.read("auth_token");

      final response = await http.get(
        Uri.parse("${Apiconstantsurl.baseUrl}${Apiconstantsurl.getusercurrentprofile}"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "success") {
          final user = data["user"];
          photo.value = user["photo"] ?? "";
          phone.value = user["phone"] ?? "";
          firstName.value = user["firstName"] ?? "";
          lastName.value = user["lastName"] ?? "";
          address.value = user["address"] ?? "";

        }
      } else {
        print("Error fetching profile: ${response.body}");
      }
    } catch (error) {
      print("Error fetching profile: $error");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> ProfilePic(File imageFile) async {
    String? token = _box.read("auth_token");

    if (token == null) {
      print("Error: No authentication token found.");
      return;
    }

    if (!imageFile.existsSync()) {
      print("Error: Image file does not exist.");
      return;
    }


    String fileExtension = imageFile.path.split('.').last.toLowerCase();


    String mimeType = "image/jpeg"; // Default MIME type
    if (fileExtension == "png") {
      mimeType = "image/png";
    } else if (fileExtension == "jpg" || fileExtension == "jpeg") {
      mimeType = "image/jpeg";
    }

    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse("${Apiconstantsurl.baseUrl}${Apiconstantsurl.updateprofilepic}"),
      );

      request.headers['Authorization'] = "Bearer $token";

      request.files.add(await http.MultipartFile.fromPath(
        "photo",
        imageFile.path,
        contentType: MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
      ));

      var response = await request.send();
      var responseStream = await response.stream.bytesToString();

      print("Response: $responseStream");

      if (response.statusCode == 200) {
        print("Profile picture updated successfully.");
        getProfileData(); // Refresh profile data
      } else {
        print("Failed to update profile picture: ${response.reasonPhrase}");
      }
    } catch (err) {
      print("Error updating profile picture: $err");
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
  }) async {
    String? token = _box.read("auth_token");

    if (token == null) {
      print("Error: No authentication token found.");
      return;
    }

    try {
      var response = await http.put(
        Uri.parse("${Apiconstantsurl.baseUrl}${Apiconstantsurl.updateuserdetails}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "firstName": firstName,
          "lastName": lastName,
          "phone": phone,
          "address": address,
        }),
      );

      if (response.statusCode == 200) {
        print("Profile updated successfully.");
        getProfileData(); // Refresh profile data
      } else {
        print("Failed to update profile: ${response.body}");
      }
    } catch (err) {
      print("Error updating profile: $err");
    }
  }

}
