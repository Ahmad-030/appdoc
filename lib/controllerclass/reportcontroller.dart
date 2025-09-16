import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Reportcontroller extends GetxController {
  var selectedImage = Rx<File?>(null);
  var isUploading = false.obs;

  // Cloudinary details — keep these correct
  final String cloudName = "dybqjhtpx";
  final String uploadPreset = "Patient_reports";

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) selectedImage.value = File(image.path);
  }

  /// Upload report. Returns true on success, false on failure.
  Future<bool> uploadReport({
    required String appointmentId,
    required String reportTitle,
  }) async {
    // quick validation
    if (selectedImage.value == null) {
      Get.snackbar("Error", "Please select an image");
      return false;
    }
    if (reportTitle.isEmpty) {
      Get.snackbar("Error", "Please enter a title");
      return false;
    }

    isUploading.value = true; // start loading

    try {
      final uploadUrl =
      Uri.parse("https://api.cloudinary.com/v1_1/dybqjhtpx/image/upload");

      var request = http.MultipartRequest("POST", uploadUrl)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          selectedImage.value!.path,
        ));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      // helpful debug (remove in production)
      print("Cloudinary response status: ${response.statusCode}");
      print("Cloudinary response body: $responseData");

      if (response.statusCode == 200) {
        var data = json.decode(responseData);
        final String imageUrl = data['secure_url'] ?? data['url'] ?? '';

        if (imageUrl.isEmpty) {
          Get.snackbar("Error", "Upload succeeded but no URL returned");
          return false;
        }

        // Save to Firestore under appointments/{appointmentId}/reports
        await FirebaseFirestore.instance
            .collection("appointments")
            .doc(appointmentId)
            .collection("reports")
            .add({
          "title": reportTitle,
          "imageUrl": imageUrl,
          "timestamp": FieldValue.serverTimestamp(),
        });

        Get.snackbar("Success", "Report uploaded successfully!");
        selectedImage.value = null; // clear selected image
        return true;
      } else {
        // show any error message Cloudinary returns
        String message;
        try {
          var decoded = json.decode(responseData);
          message = decoded['error']?.toString() ?? responseData;
        } catch (_) {
          message = responseData;
        }
        Get.snackbar("Error", "Cloudinary upload failed: $message");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Upload failed: $e");
      print("Upload exception: $e");
      return false;
    } finally {
      isUploading.value = false; // always stop loading
    }
  }
}
