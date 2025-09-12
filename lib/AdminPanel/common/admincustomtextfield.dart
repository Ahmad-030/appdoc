import 'package:flutter/material.dart';

class Admincustomtextfield extends StatelessWidget {
  final String hintText;
  TextEditingController? edcontroller;
  int? minlines;

   Admincustomtextfield({Key? key, required this.hintText,this.edcontroller,this.minlines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: edcontroller,
        minLines: minlines,
        maxLines: null,
        style: TextStyle(
          fontFamily: 'poppins'
        ),
        decoration: InputDecoration(
          hintText: hintText,
          filled: true, // Enables the background color
          fillColor: Colors.grey[200], // Sets the grey background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Optional: Rounded corners
            borderSide: BorderSide.none, // Removes the border
          ),

        ),
      ),
    );
  }
}