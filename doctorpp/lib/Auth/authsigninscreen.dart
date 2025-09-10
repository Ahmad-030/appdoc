import 'package:doctorappflutter/Auth/signinComponents/signinbody.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Authsigninscreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Signinbody(),
    );
  }

}