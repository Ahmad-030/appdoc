import 'package:doctorappflutter/Auth/forgotcomponent/forgotbody.dart';
import 'package:flutter/material.dart';

class Forgotpasswordscreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Forgotbody(),
    );
  }

}