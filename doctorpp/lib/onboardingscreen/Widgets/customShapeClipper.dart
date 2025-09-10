import 'package:flutter/cupertino.dart';

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Define the same path as used for the shape in the `TicketClipper`.
    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(size.width * -0.05, size.height * -0.05,
        size.width * 0.2, 0);
    path.lineTo(size.width * 0.85, 0);
    path.quadraticBezierTo(size.width + size.width * 0.05,
        size.height * -0.05, size.width, size.height * 0.2);
    path.lineTo(size.width, size.height * 0.85);
    path.quadraticBezierTo(size.width + size.width * 0.05,
        size.height + size.height * 0.05, size.width * 0.85, size.height);
    path.lineTo(size.width * 0.2, size.height);
    path.quadraticBezierTo(size.width * -0.05, size.height + size.height * 0.05,
        0, size.height * 0.85);
    path.lineTo(0, size.height * 0.60);
    path.arcToPoint(Offset(0, size.height * 0.36),
        radius: Radius.circular(size.width * 0.1), clockwise: false);
    path.lineTo(0, size.height * 0.2);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}