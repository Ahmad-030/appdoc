import 'package:doctorappflutter/Auth/signupcomponents/signupbody.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Authsignupscreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
       backgroundColor: Colors.white,
      body: SignupBody(),
    );
  }

}