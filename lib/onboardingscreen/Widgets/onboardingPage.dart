
import 'package:doctorappflutter/onboardingscreen/Widgets/ticketClipper.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;



class OnboardingPage extends StatelessWidget {
  const OnboardingPage ({super.key, required this.image, required this.title});

  final ui.Image image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -60, // Positioning the shape slightly off-screen
          right: -60,
          child: CustomPaint(
            size: const Size(350, 410), // Adjust size as needed
            painter: TicketClipper(image),
          ),
        ),
      ],
    );
  }
}
