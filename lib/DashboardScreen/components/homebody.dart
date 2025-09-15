import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AdminPanel/controller/acceptedAppointmentController.dart';
import '../../Auth/signinComponents/similar/headerdesign.dart';
import '../../chat/PatientSide/patientchatUI.dart';
import '../../controllerclass/getdoctordetails.dart';
import '../../DashboardScreen/components/similardesign/containerdesing.dart';
import '../../DashboardScreen/components/similardesign/homecards.dart';
import '../../DashboardScreen/DashboardDetailsScreen/medicinedetails.dart';
import '../../DashboardScreen/DashboardDetailsScreen/reportsdetails.dart';
import '../../DashboardScreen/components/homedoctor/doctor.dart';
import '../../constant/constantfile.dart';
import '../../ahmadswork/Pending_approval.dart';
import '../../DashboardScreen/DashboardDetailsScreen/aboutdoctor.dart';

class Homebody extends StatefulWidget {
  @override
  State<Homebody> createState() => _HomebodyState();
}

class _HomebodyState extends State<Homebody> {
  final GetDoctorDetails controller = Get.put(GetDoctorDetails());
  final AcceptedAppointmentController appointmentController =
  Get.put(AcceptedAppointmentController());

  @override
  void initState() {
    super.initState();
    controller.fetchDoctorDetails();
    appointmentController.fetchAcceptedAppointments();

    // Set status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: customBlue,
      statusBarIconBrightness: Brightness.light,
    ));

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
      await prefs.setBool('cameraPermissionChecked', true);
    }
  }

  Future<void> _requestCameraPermission() async {
    var camera = await Permission.camera.request();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          camera.isGranted
              ? "Camera permission granted ✅"
              : "Camera permission denied ❌",
        ),
      ),
    );
  }

  Future<void> _showPermissionDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border:
                  Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
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
                          fontWeight: FontWeight.bold),
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
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            elevation: 0,
                          ),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: const Text("Deny",
                              style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            Navigator.of(dialogContext).pop();
                            await _requestCameraPermission();
                          },
                          child: const Text("Allow",
                              style: TextStyle(color: Colors.white)),
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

  Widget _pendingApprovalScreen(double screenHeight, double screenWidth) {
    return PendingApprovalScreen();
  }

  Widget _homeBody(double screenHeight, double screenWidth, bool accepted) {
    // Pick the first accepted appointment dynamically
    final appointment = appointmentController.appointments.isNotEmpty
        ? appointmentController.appointments.first
        : null;

    return Column(
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
                    onpressed: () => Get.to(ReportsDetails()),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Homecards(
                    text: 'Medicine',
                    imagePath: 'assets/images/medicine.png',
                    onpressed: () => Get.to(Medicinedetails()),
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
                            offset: Offset(0, 3)),
                      ],
                    ),
                    child: Doctor(),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  if (appointment != null)
                    CustomContainer(
                      onpressed: () {
                        Get.to(() => PatientChatScreen(
                          appointmentId: appointment.id,
                          patientId: appointment.id,
                          doctorName:
                          "${appointment.doctorFirstName} ${appointment.doctorLastName}",
                        ));
                      },
                      height: screenHeight * 0.08,
                      color: customBlue,
                      text: 'Whatsapp',
                      textColor: Colors.white,
                    )
                  else
                    CustomContainer(
                      onpressed: () => Get.to(() => Aboutdoctor()),
                      height: screenHeight * 0.08,
                      color: customBlue,
                      text: 'About Doctor',
                      textColor: Colors.white,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      final hasAppointment = appointmentController.appointments.isNotEmpty;

      return Scaffold(
        backgroundColor: Colors.white,
        body: hasAppointment
            ? (appointmentController.isAccepted.value
            ? _homeBody(screenHeight, screenWidth, true)
            : _pendingApprovalScreen(screenHeight, screenWidth))
            : _homeBody(screenHeight, screenWidth, false),
      );
    });
  }
}
