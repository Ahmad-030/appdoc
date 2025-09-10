import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Reportcontroller extends GetxController{
  // Observable variable to hold the selected image
  var selectedImage = Rx<File?>(null);

  // Method to pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }
}