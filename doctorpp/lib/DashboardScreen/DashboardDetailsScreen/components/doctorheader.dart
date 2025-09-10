import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Doctorheader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        color: customBlue,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        child: Image.asset(
          "assets/images/doctorimage.jpg",
          fit: BoxFit.cover, // Ensures the image covers the entire container
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
