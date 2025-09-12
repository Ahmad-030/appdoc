import 'package:doctorappflutter/Auth/resetpassworddetails.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Resetpasswordscreen extends StatefulWidget {
  final String useremail;

  Resetpasswordscreen({required this.useremail});

  @override
  _ResetpasswordscreenState createState() => _ResetpasswordscreenState();
}

class _ResetpasswordscreenState extends State<Resetpasswordscreen> {
  String otpCode = "";
  bool isOtpFilled = false;

  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'OTP Verification',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: customBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(child: Image.asset('assets/images/otpimage.png', height: 350)),
              const SizedBox(height: 10),
              const Text(
                'OTP VERIFICATION',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Email: ${widget.useremail}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'We have sent the code to your email. Please check your email.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    child: TextField(
                      controller: otpControllers[index],
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: customBlue), // Default border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: customBlue), // Border color when focused
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                        otpCode = otpControllers.map((controller) => controller.text).join();
                        setState(() {
                          isOtpFilled = otpCode.length == 6;
                        });
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              const Text(
                'Didn’t receive Code?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add your resend OTP logic here
                },
                child: const Text(
                  'Resend OTP',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: customBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: isOtpFilled
              ? () {
            Get.to(Resetpassworddetails(email: widget.useremail, otp: otpCode));
          }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isOtpFilled ? customBlue : Colors.grey,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            'Continue',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
