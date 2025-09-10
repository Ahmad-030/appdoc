import 'package:doctorappflutter/controllerclass/reportcontroller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsDetails extends StatelessWidget {
  const ReportsDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final Reportcontroller controller = Get.put(Reportcontroller());
    // Get the screen size using MediaQuery
    var screenSize = MediaQuery.of(context).size;

    // Get the screen width and height
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    // Define padding and font sizes relative to screen size
    double horizontalPadding = screenWidth * 0.02; // 5% of screen width
    double verticalPadding = screenHeight * 0.02; // 2% of screen height
    double fontSizeTitle = screenWidth * 0.05; // Font size 5% of screen width
    double fontSizeText = screenWidth * 0.045; // Font size 4.5% of screen width
    double buttonWidth = screenWidth * 0.6; // Button width 60% of screen width
    double buttonHeight = screenHeight * 0.06; // Button height 6% of screen height

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Add your back button logic here
          },
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
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Call the pick image method when tapped
                            controller.pickImageFromGallery();
                          },
                          child: Obx(
                                () => DottedBorder(
                              dashPattern: [6],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate,
                                          size: 50,
                                          color: Colors.blueAccent,
                                        ),
                                        Text('Click here to add reports', style: TextStyle(
                                            fontFamily: 'Poppins'
                                        ),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: verticalPadding * 2),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            const BoxShadow(
                              blurStyle: BlurStyle.normal,
                              blurRadius: 1,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          style: TextStyle(fontSize: fontSizeText),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.receipt_long,
                              color: Colors.blueAccent,
                            ),
                            hintText: "Enter report title here",
                            hintStyle: TextStyle(fontSize : fontSizeText, fontFamily: 'Poppins'),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: verticalPadding,left: 15,right: 15),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: buttonWidth * 0.4, vertical: buttonHeight * 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'
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
