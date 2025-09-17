import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ReportController extends GetxController {
  var selectedImage = Rx<File?>(null);
  var isUploading = false.obs;

  // Cloudinary details
  final String cloudName = "dybqjhtpx";
  final String uploadPreset = "Patient_reports";

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
      print("✅ Image selected: ${image.path}");
    }
  }

  /// Upload report. Returns true on success, false on failure.
  Future<bool> uploadReport({
    required String appointmentId,
    required String reportTitle,
  }) async {
    // ---- Validation before setting loading ----
    if (selectedImage.value == null) {
      Get.snackbar("Error", "Please select an image");
      return false;
    }
    if (reportTitle.isEmpty) {
      Get.snackbar("Error", "Please enter a title");
      return false;
    }

    isUploading.value = true;
    try {
      // ---- 1. Upload to Cloudinary ----
      print("📤 Uploading to Cloudinary...");
      final uploadUrl =
      Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      var request = http.MultipartRequest("POST", uploadUrl)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          selectedImage.value!.path,
        ));

      var response =
      await request.send().timeout(const Duration(seconds: 30));
      var responseData = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        String message = responseData;
        try {
          var decoded = json.decode(responseData);
          message = decoded['error']?.toString() ?? responseData;
        } catch (_) {}
        Get.snackbar("Error", "Cloudinary upload failed: $message");
        return false;
      }

      var data = json.decode(responseData);
      final String imageUrl = data['secure_url'] ?? data['url'] ?? '';
      if (imageUrl.isEmpty) {
        Get.snackbar("Error", "Upload succeeded but no URL returned");
        return false;
      }
      print("✅ Uploaded to Cloudinary: $imageUrl");

      // ---- 2. Save in Firestore ----
      try {
        print("📝 Saving to Firestore...");
        final reportData = {
          "title": reportTitle,
          "imageUrl": imageUrl,
          "appointmentId": appointmentId,
          "timestamp": FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection("appointments")
            .doc(appointmentId)
            .collection("reports")
            .add(reportData);

        print("✅ Saved in Firestore");
      } catch (e) {
        print("❌ Firestore error: $e");
        Get.snackbar("Error", "Failed to save report in Firestore: $e");
        return false;
      }

      Get.snackbar("Success", "Report uploaded successfully!");
      selectedImage.value = null;
      return true;
    } catch (e) {
      Get.snackbar("Error", "Upload failed: $e");
      print("❌ Upload exception: $e");
      return false;
    } finally {
      // ---- Always reset loading ----
      isUploading.value = false;
      print("⏹️ Upload process finished, loader stopped.");
    }
  }
}
