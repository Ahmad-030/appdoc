
import 'dart:ui' as ui;

import 'package:doctorappflutter/onboardingscreen/Widgets/onboardingPage.dart';
import 'package:doctorappflutter/onboardingscreen/controller/onBoardingController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final OnBoardingController controller = Get.put(OnBoardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(
                    () {
                  if (controller.screen.isEmpty) {
                    // Show a loading indicator while the images are being loaded
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final currentPage = controller.currentPage.value;
                  final currentScreen = controller.screen[currentPage];
                  return OnboardingPage(
                    image: currentScreen.image,
                    title: currentScreen.title,
                  );
                },
              ),
            ),
            Obx(
                  () {
                if (controller.screen.isEmpty) {
                  return const SizedBox(); // Empty widget while loading
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 40.0),
                  child: Text(
                    controller.screen[controller.currentPage.value].title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                        fontFamily: 'Poppins'
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Obx(
                  () {
                if (controller.screen.isEmpty) {
                  return const SizedBox(); // Empty widget while loading
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    controller.screen.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      curve: Curves.easeInOut,
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                          color: controller.currentPage.value == index
                              ? Colors.blue
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E90FF), // Custom blue color
                    foregroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(vertical: 16), // Adjust padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  child: const Text("Continue",style: TextStyle(
                    fontFamily: 'Poppins'
                  ),),
                ),
              ),
            )
            ,
            const SizedBox(
              height: 13,
            ),
            const Center(
                child: Text(
                  "We Humbly Welcome You ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily:  'Poppins', fontSize: 13),
                ))
          ],
        ),
      ),
    );
  }
}
