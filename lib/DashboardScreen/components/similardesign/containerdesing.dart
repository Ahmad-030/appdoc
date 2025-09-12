import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final double height;
  final Color color;
  final String text;
  final Color textColor;
  final double borderRadius;
  final VoidCallback onpressed;

  CustomContainer({
    required this.height,
    required this.color,
    required this.text,
    this.textColor = Colors.white,
    this.borderRadius = 10.0,
    required this.onpressed
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'
            ),
          ),
        ),
      ),
    );
  }
}
