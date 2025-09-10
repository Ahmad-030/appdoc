import 'package:doctorappflutter/Auth/authsignupscreen.dart';
import 'package:doctorappflutter/Auth/forgotpasswordscreen.dart';
import 'package:doctorappflutter/Auth/signinComponents/similar/custombutton.dart';
import 'package:doctorappflutter/Auth/signinComponents/similar/headerdesign.dart';
import 'package:doctorappflutter/Auth/signinComponents/similar/textfeild.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:doctorappflutter/controllerclass/sIgnInAuthcontroller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Signinbody extends StatefulWidget {
  @override
  State<Signinbody> createState() => _SigninbodyState();
}

class _SigninbodyState extends State<Signinbody> {
  final Signinauthcontroller signInController = Get.put(Signinauthcontroller());
  final TextEditingController emailController = TextEditingController();

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
              children: [
                Headerdesign(),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "SIGNIN",
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
                    title: "Enter email here",
                    icon: Icons.email,
                    controller: emailController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  child: CustomTextField(
                    title: "Enter password here",
                    icon: Icons.lock,
                    controller: passwordController,
                      obscureText: true
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Get.to(Forgotpasswordscreen());
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: customBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 35.0),
                  child: Obx(
                        () => CustomButton(
                      title: "SIGN IN",
                      isLoading: signInController.isloading.value, // Pass loading state
                      onPressed: () async {

                        await signInController.signinuser(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                      },

                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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
                    text: "DON'T HAVE AN ACCOUNT? ",
                    style: const TextStyle(
                      color: Colors.grey, // Base text color
                    ),
                    children: [
                      TextSpan(
                        text: "SIGN UP",
                        style: const TextStyle(
                          color: Colors.blue, // Color for the SIGN UP text
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(Authsignupscreen());
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

