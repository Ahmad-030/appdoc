import 'package:flutter/material.dart';
import 'package:doctorappflutter/constant/constantfile.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLoading; // Use this parameter to show the loader

  const CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.isLoading = false, // Default value set to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed, // Disable button tap when loading
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isLoading ? Colors.blue.shade300 : customBlue, // Change color slightly when loading
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          )
              : Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}
