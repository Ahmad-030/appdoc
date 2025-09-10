import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/cupertino.dart';

class Headerdesign extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 220,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            color: customBlue,
          ),
          child: Center(child: Image.asset("assets/images/loginandsignup.png")),
        ),
      ],
    );
  }

}