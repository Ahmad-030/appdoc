import 'package:doctorappflutter/DashboardScreen/components/exercisebody.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/material.dart';

class Exercisescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exercise Screen",style: TextStyle(fontFamily: 'Poppins',color: Colors.white),),
        backgroundColor: customBlue,
      ),
      body: ExerciseBody(),
    );
  }
}
