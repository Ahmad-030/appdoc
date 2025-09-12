
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

class UploadExerciseController extends GetxController {
  var selectedImagePath = ''.obs;
  var selectedVideoPath = ''.obs;
  var isLoading = false.obs;

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImagePath.value = image.path;
      } else {
        Get.snackbar("Error", "No image selected", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> pickVideo() async {
    try {
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        selectedVideoPath.value = video.path;
      } else {
        Get.snackbar("Error", "No video selected", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error picking video: $e");
    }
  }




}
