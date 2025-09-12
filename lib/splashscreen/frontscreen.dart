import 'dart:async';
import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/adminnavbottom.dart';
import 'package:doctorappflutter/DashboardScreen/userbottomnav.dart';
import 'package:doctorappflutter/StorageServiceClass/storageservice.dart';
import 'package:doctorappflutter/onboardingscreen/onboardingScreen.dart';
import 'package:doctorappflutter/splashscreen/splashcomponent/splashcomponent.dart';
import 'package:flutter/material.dart';
import '../constant/constantfile.dart';

class Frontscreen extends StatefulWidget {
  @override
  State<Frontscreen> createState() => _FrontscreenState();
}

class _FrontscreenState extends State<Frontscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      checkLoginStatus();
    });
  }

  void checkLoginStatus() {
    final storage = StorageService();
    String? token = storage.readToken();
    String? role = storage.readRole();

    if (token != null && token.isNotEmpty) {
      // Navigate based on role
      if (role == "patient") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Userbottomnav()));
      } else if (role == "doctor") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Adminnavbottom()));
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => OnboardingScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customBlue,
      body: Splashcomponent(),
    );
  }
}
