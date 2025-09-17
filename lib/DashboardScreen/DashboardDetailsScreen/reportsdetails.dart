import 'package:doctorappflutter/controllerclass/reportcontroller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsDetails extends StatelessWidget {
  final String appointmentId;
  ReportsDetails({super.key, required this.appointmentId});
  final ReportController controller = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController());
  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    double horizontalPadding = screenWidth * 0.02;
    double verticalPadding = screenHeight * 0.02;
    double fontSizeText = screenWidth * 0.045;
    double buttonWidth = screenWidth * 0.6;
    double buttonHeight = screenHeight * 0.06;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Add Reports',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: verticalPadding),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Add Your Report Details Here',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: verticalPadding),
                    GestureDetector(
                      onTap: () => controller.pickImageFromGallery(),
                      child: Obx(
                            () => DottedBorder(
                          dashPattern: [6],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          child: ClipRRect(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[200],
                              child: controller.selectedImage.value != null
                                  ? Image.file(
                                controller.selectedImage.value!,
                                fit: BoxFit.cover,
                              )
                                  : const Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate,
                                        size: 50,
                                        color: Colors.blueAccent),
                                    Text(
                                      'Click here to add reports',
                                      style: TextStyle(
                                          fontFamily: 'Poppins'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: verticalPadding * 2),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: TextField(
                        controller: titleController,
                        style: TextStyle(fontSize: fontSizeText),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.receipt_long,
                              color: Colors.blueAccent),
                          hintText: "Enter report title here",
                          hintStyle: TextStyle(
                              fontSize: fontSizeText, fontFamily: 'Poppins'),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ----------------- Submit button -----------------
            Container(
              width: double.infinity,
              padding:
              EdgeInsets.only(bottom: verticalPadding, left: 15, right: 15),
              child: Obx(
                    () => ElevatedButton(
                  onPressed: controller.isUploading.value
                      ? null
                      : () async {
                    if (titleController.text.trim().isEmpty) {
                      Get.snackbar("Error", "Please enter a report title");
                      return;
                    }
                    if (controller.selectedImage.value == null) {
                      Get.snackbar("Error",
                          "Please select a report image first");
                      return;
                    }

                    bool ok = await controller.uploadReport(
                      appointmentId: appointmentId,
                      reportTitle: titleController.text.trim(),
                    );

                    if (ok) {
                      titleController.clear();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isUploading.value
                        ? Colors.blue.shade300
                        : Colors.blue,
                    padding: EdgeInsets.symmetric(
                        horizontal: buttonWidth * 0.4,
                        vertical: buttonHeight * 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: controller.isUploading.value
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
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
