import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/bottomnavcomponents/aboutdoctocomponents/addaboutdoctor.dart';
import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/bottomnavcomponents/aboutdoctocomponents/viewdoctorprofile.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/material.dart';

class Aboutdoctorbody extends StatefulWidget {
  @override
  State<Aboutdoctorbody> createState() => _AboutdoctorbodyState();
}

class _AboutdoctorbodyState extends State<Aboutdoctorbody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: customBlue,
        title: const Text(
          "About Doctor",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false, // Prevents the back icon from appearing
      ),
      body:
          Viewdoctorprofile(),


    );
  }
}
