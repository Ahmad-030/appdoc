import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homecards extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback onpressed;

  Homecards({required this.text, required this.imagePath, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(15), // Added padding inside the container
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Center the content vertically
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(imagePath),
            ),
            SizedBox(width: 10), // Add some spacing between the image and text
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'
              ),
            ),
          ],
        ),
      ),
    );
  }
}
