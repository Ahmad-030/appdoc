import 'package:doctorappflutter/Auth/authsignupscreen.dart';
import 'package:doctorappflutter/Auth/signinComponents/similar/custombutton.dart';
import 'package:doctorappflutter/Auth/signinComponents/similar/headerdesign.dart';
import 'package:doctorappflutter/Auth/signinComponents/similar/textfeild.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:doctorappflutter/controllerclass/resetpasswordController.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Resetpassworddetails extends StatefulWidget {
  final String email;
  final String otp;

  Resetpassworddetails({required this.email, required this.otp});

  @override
  State<Resetpassworddetails> createState() => _ResetpassworddetailsState();
}

class _ResetpassworddetailsState extends State<Resetpassworddetails> {
  final Resetpasswordcontroller Controller = Get.put(Resetpasswordcontroller());
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conpasswordController = TextEditingController();

  // Method to clear text fields
  void _clearFields() {
    passwordController.clear();
    conpasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Headerdesign(),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        "RESET PASSWORD",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: customBlue,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                      child: CustomTextField(
                        title: "New password here",
                        icon: Icons.lock,
                        controller: passwordController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                      child: CustomTextField(
                        title: "Confirm password here",
                        icon: Icons.lock,
                        controller: conpasswordController,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 35.0),
                      child: Obx(
                            () => CustomButton(
                          title: "RESET PASSWORD",
                          isLoading: Controller.isLoading.value,
                          onPressed: () async {
                            await Controller.resetPass(
                              email: widget.email,
                              pass: passwordController.text.trim(),
                              conpass: conpasswordController.text.trim(),
                              otp: widget.otp,
                              onSuccess: _clearFields, // Pass the callback to clear fields
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: "DON'T HAVE AN ACCOUNT? ",
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: "SIGN UP",
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () => Get.to(Authsignupscreen()),
                      ),
                    ],
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