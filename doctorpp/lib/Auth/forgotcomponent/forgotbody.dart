
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constantfile.dart';
import '../../controllerclass/forgotpasscontroller.dart';
import '../authsigninscreen.dart';
import '../signinComponents/similar/custombutton.dart';
import '../signinComponents/similar/headerdesign.dart';
import '../signinComponents/similar/textfeild.dart';

class Forgotbody extends StatefulWidget{
  @override
  State<Forgotbody> createState() => _ForgotbodyState();
}

class _ForgotbodyState extends State<Forgotbody> {
  final Forgotpasscontroller forgotpasscontroller = Get.put(Forgotpasscontroller());
  final TextEditingController forgottextcontroller= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Headerdesign(),
              const SizedBox(height: 20,),
              const Text("Forgot Password",style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: customBlue,
                  fontFamily: 'Poppins'
              ),),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                child: CustomTextField(title: 'Enter email here',icon: Icons.email,controller: forgottextcontroller,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 35.0),
                child: Obx(
                      () => CustomButton(
                    title: "SUBMIT",
                    isLoading: forgotpasscontroller.isLoading.value, // Pass loading state
                    onPressed: () async {

                      await forgotpasscontroller.userforgotpass(
                        useremail: forgottextcontroller.text.trim(),

                      );
                    },

                  ),
                ),
              )

            ],
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
                    text: "ALREADY HAVE AN ACCOUNT? ",
                    style: const TextStyle(
                      color: Colors.grey, // Base text color
                    ),
                    children: [
                      TextSpan(
                        text: "SIGN IN",
                        style: const TextStyle(
                          color: Colors.blue, // Color for the SIGN UP text
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle the SIGN UP tap event
                            Get.to(Authsigninscreen());
                            // Navigate to the SIGN UP screen or perform any action
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