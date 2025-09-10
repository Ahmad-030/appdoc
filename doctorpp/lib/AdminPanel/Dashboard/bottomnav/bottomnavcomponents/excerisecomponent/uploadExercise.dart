import 'dart:convert';
import 'dart:io';
import 'package:doctorappflutter/AdminPanel/controller/uploadExerciseController.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UploadExercise extends StatelessWidget {
  final UploadExerciseController controller = Get.put(UploadExerciseController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Exercise Title Here',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter here",
              ),
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Enter Exercise Description Here',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter here",
              ),
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Pick Image From Gallery',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 12),
            Obx(() {
              return Container(
                width: double.infinity,
                child: controller.selectedImagePath.value.isNotEmpty
                    ? Image.file(File(controller.selectedImagePath.value), fit: BoxFit.contain)
                    : InkWell(
                  onTap: controller.pickImage,
                  child: Image.asset('assets/images/imagepick.jpg', fit: BoxFit.contain),
                ),
              );
            }),
            const SizedBox(height: 10),
            const Text(
              'Pick Video From Gallery',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 10),
            Obx(() {
              return Container(
                width: double.infinity,
                child: controller.selectedVideoPath.value.isNotEmpty
                    ? Image.file(
                  File(controller.selectedVideoPath.value),
                  fit: BoxFit.cover,
                  height: 170,
                )
                    : InkWell(
                  onTap: controller.pickVideo,
                  child: Image.asset(
                    'assets/images/videoimage.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              );

            }),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  if (controller.selectedImagePath.isEmpty ||
                      controller.selectedVideoPath.isEmpty ||
                      titleController.text.isEmpty ||
                      descriptionController.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please fill all fields and select both an image and a video",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: customBlue,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {

                  }
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: const Center(
                    child: Text(
                      'Upload Video',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
