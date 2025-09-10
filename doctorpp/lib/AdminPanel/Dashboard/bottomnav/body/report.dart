import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/bottomnavcomponents/reportcomponents/viewpatientreport.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Report extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: customBlue,
        title: const Text('View Report',style: TextStyle(
          color: Colors.white,
          fontFamily: 'poppins',
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),),
          automaticallyImplyLeading: false
      ),
      body: Viewpatientreport(),
    );
  }

}