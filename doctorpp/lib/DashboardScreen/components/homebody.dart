import 'dart:ui';
import 'package:doctorappflutter/Auth/signinComponents/similar/headerdesign.dart';
import 'package:doctorappflutter/DashboardScreen/DashboardDetailsScreen/aboutdoctor.dart';
import 'package:doctorappflutter/DashboardScreen/DashboardDetailsScreen/medicinedetails.dart';
import 'package:doctorappflutter/DashboardScreen/DashboardDetailsScreen/reportsdetails.dart';
import 'package:doctorappflutter/DashboardScreen/components/homedoctor/doctor.dart';
import 'package:doctorappflutter/DashboardScreen/components/similardesign/containerdesing.dart';
import 'package:doctorappflutter/DashboardScreen/components/similardesign/homecards.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllerclass/getdoctordetails.dart';

class Homebody extends StatefulWidget {
  @override
  State<Homebody> createState() => _HomebodyState();
}

class _HomebodyState extends State<Homebody> {
  final GetDoctorDetails controller = Get.put(GetDoctorDetails());

  @override
  void initState() {
    super.initState();
    controller.fetchDoctorDetails();

    // Delay permission check until after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCameraPermissionOnce();
    });
  }

  Future<void> _checkCameraPermissionOnce() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyChecked = prefs.getBool('cameraPermissionChecked') ?? false;

    if (!alreadyChecked) {
      bool cameraGranted = await Permission.camera.isGranted;

      if (!cameraGranted && mounted) {
        _showPermissionDialog();
      }

      // ✅ Mark as checked so dialog shows only once
      await prefs.setBool('cameraPermissionChecked', true);
    }
  }

  Future<void> _requestCameraPermission() async {
    var camera = await Permission.camera.request();

    if (!mounted) return;

    if (camera.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera permission granted ✅")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera permission denied ❌")),
      );
    }
  }

  Future<void> _showPermissionDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false, // user must choose
      builder: (BuildContext dialogContext) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: MediaQuery.of(dialogContext).size.width * 0.85,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15), // glass effect
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3), // frosted border
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_person_rounded,
                        size: 60, color: Colors.white),
                    const SizedBox(height: 15),
                    const Text(
                      "Permission Required",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "This app needs access to your Camera & Gallery.\n\n",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                          child: const Text(
                            "Deny",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            Navigator.of(dialogContext).pop();
                            await _requestCameraPermission();
                          },
                          child: const Text(
                            "Allow",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          Headerdesign(),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Homecards(
                      text: 'Reports',
                      imagePath: 'assets/images/result.png',
                      onpressed: () {
                        Get.to(ReportsDetails());
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Homecards(
                      text: 'Medicine',
                      imagePath: 'assets/images/medicine.png',
                      onpressed: () {
                        Get.to(Medicinedetails());
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  children: [
                    Container(
                      height: screenHeight * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Doctor(),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Obx(() {
                      return CustomContainer(
                        onpressed: () {
                          Get.to(Aboutdoctor());
                        },
                        height: screenHeight * 0.08,
                        color: controller.isLoading.value
                            ? Colors.grey
                            : customBlue,
                        text: 'About Doctor',
                        textColor: Colors.white,
                      );
                    }),
                    SizedBox(height: screenHeight * 0.015),
                    CustomContainer(
                      onpressed: () {},
                      height: screenHeight * 0.08,
                      color: Colors.grey,
                      text: 'Whatsapp',
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
