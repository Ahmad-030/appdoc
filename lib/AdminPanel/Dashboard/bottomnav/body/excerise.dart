import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/body/adminexcerisebody.dart';
import 'package:doctorappflutter/DashboardScreen/components/exercisebody.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Excerise extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise Video",style: TextStyle(fontFamily: 'Poppins',color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18,
        ),),

        backgroundColor: customBlue,
      ),
      body: ExerciseBody(),
    );
  }

}

