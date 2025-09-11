import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ Required for status bar control
import 'package:get/get.dart';
import '../AdminPanel/controller/acceptedAppointmentController.dart';
import '../DashboardScreen/components/homebody.dart';
import '../constant/constantfile.dart'; // ✅ Make sure customBlue is defined here

class PendingApprovalScreen extends StatelessWidget {
  final AcceptedAppointmentController controller =
  Get.put(AcceptedAppointmentController());

  @override
  Widget build(BuildContext context) {
    // ✅ Change status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: customBlue, // set your custom blue color
      statusBarIconBrightness: Brightness.light, // white icons
    ));

    return Obx(() {
      if (controller.isAccepted.value) {
        Future.microtask(() => Get.offAll(() => Homebody()));
      }

      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/loading.png",
                height: 160,
                width: 160,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                "Your appointment is pending approval",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "Once approved, you will be redirected automatically.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(color: Colors.blue),
            ],
          ),
        ),
      );
    });
  }
}
