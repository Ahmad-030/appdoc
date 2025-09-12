import 'package:doctorappflutter/DashboardScreen/DashboardDetailsScreen/components/medbody.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Medicinedetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Medicine Details',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
        ),
        backgroundColor: customBlue,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the icons to white
        ),
      ),
      body: Medbody(),
    );
  }
}
