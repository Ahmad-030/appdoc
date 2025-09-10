
import 'package:doctorappflutter/Auth/authsigninscreen.dart';
import 'package:doctorappflutter/Auth/signinComponents/similar/custombutton.dart';
import 'package:doctorappflutter/Auth/signinComponents/similar/headerdesign.dart';
import 'package:doctorappflutter/Auth/signinComponents/similar/textfeild.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:doctorappflutter/controllerclass/signupAuthcontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignupBody extends StatefulWidget {

  SignupBody({Key? key}) : super(key: key);

  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  final Signupauthcontroller signupController = Get.put(Signupauthcontroller());

  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Design
                Headerdesign(),
                const SizedBox(height: 20),
                // Signup Title
                const Center(
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // First Name and Last Name Fields
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: firstNameController,
                          title: "First name",
                          icon: Icons.person,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          controller: lastNameController,
                          title: "Last name",
                          icon: Icons.person,
                        ),
                      ),
                    ],
                  ),
                ),
                // Email Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  child: CustomTextField(
                    controller: emailController,
                    title: 'Email',
                    icon: Icons.email,
                  ),
                ),
                // Phone Number Field
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  child: CustomTextField(
                    controller: phoneController,
                    title: 'Phone number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,

                  ),
                ),
                // Password Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  child: CustomTextField(
                    controller: passwordController,
                    title: 'Password',
                    icon: Icons.lock,
                      obscureText: true

                  ),
                ),
                // Signup Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 35.0),
                  child: Obx(
                        () => CustomButton(
                      title: "SIGN UP",
                      isLoading: signupController.isLoading.value, // Pass loading state
                            onPressed: () async {

                              await signupController.registerUser(
                                firstName: firstNameController.text.trim(),
                                lastName: lastNameController.text.trim(),
                                email: emailController.text.trim(),
                                phone: phoneController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                            },

                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
      // Bottom Navigation with "Sign In" text
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: "ALREADY HAVE AN ACCOUNT? ",
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: "SIGN IN",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(Authsigninscreen());
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}