
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'dart:math' as math;

class TicketClipper extends CustomPainter {
  final ui.Image image;

  TicketClipper(this.image);

  @override
  void paint(Canvas canvas, Size size) {
// Move Canvas to center the rotation around the bottom-left corner
    canvas.translate(size.width / 2, size.height / 2);

    // Rotate Canvas 45 degree
    canvas.rotate(-math.pi / 4); // Use a negative angle for clockwise rotation

    // Move Canvas back to origin
    canvas.translate(-size.width / 2, -size.height / 2);

    // Shadow Path
    Path shadowPath = buildPath(size);
    canvas.drawShadow(
      shadowPath, // Path for the shadow
      Colors.black.withOpacity(0.8), // Shadow color
      16.0, // Elevation or blur radius
      true, // Opaque shadows
    );

    // Paint image inside the rotated shape
    Paint imagePaint = Paint();
    Path imagePath = buildPath(size);

    canvas.save();
    canvas.clipPath(imagePath);

    // Calculate source and destination rectangles for BoxFit.cover
    final double imageAspectRatio = image.width / image.height;
    final double canvasAspectRatio = size.width / size.height;

    Rect srcRect;
    if (imageAspectRatio > canvasAspectRatio) {
      // Image is wider than canvas
      final double scaledHeight = image.height.toDouble();
      final double scaledWidth = scaledHeight * canvasAspectRatio;
      final double left = (image.width - scaledWidth) / 2;
      srcRect = Rect.fromLTWH(left, 0, scaledWidth, scaledHeight);
    } else {
      // Image is taller than canvas
      final double scaledWidth = image.width.toDouble();
      final double scaledHeight = scaledWidth / canvasAspectRatio;
      final double top = (image.height - scaledHeight) / 2;
      srcRect = Rect.fromLTWH(0, top, scaledWidth, scaledHeight);
    }

    // Destination rectangle
    final Rect dstRect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Draw the image with the calculated rectangles
    canvas.drawImageRect(image, srcRect, dstRect, imagePaint);

    canvas.restore();

    // Draw the main shape
    Paint paint = Paint()..color = Colors.transparent;
    Path path = buildPath(size);
    canvas.drawPath(path, paint);

    // Draw dotted line
    Paint dottedPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    double dashWidth = 6, dashSpace = 6, startX = size.width * 0.2;

    while (startX < size.width * 0.8) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        dottedPaint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  Path buildPath(Size size) {
    Path path = Path();

    // Start at the top-left
    path.moveTo(0, size.height * 0.2);

    // Top-left rounded corner
    path.quadraticBezierTo(
      size.width * -0.05, size.height * -0.05, // Control point
      size.width * 0.2, 0, // End point
    );

    // Top-right rounded corner
    path.lineTo(size.width * 0.85, 0);
    path.quadraticBezierTo(
      size.width + size.width * 0.05, size.height * -0.05, // Control point
      size.width, size.height * 0.2, // End point
    );

    // Right side edge
    path.lineTo(size.width, size.height * 0.85);

    // Bottom-right rounded corner
    path.quadraticBezierTo(
      size.width + size.width * 0.05, size.height + size.height * 0.05, // Control point
      size.width * 0.85, size.height, // End point
    );

    // Bottom-left semi-circle cut
    path.lineTo(size.width * 0.2, size.height);
    path.quadraticBezierTo(
      size.width * -0.05, size.height + size.height * 0.05, // Control point
      0, size.height * 0.85, // End point
    );

    // Inward Half-Circle Cut
    path.lineTo(0, size.height * 0.60); // Move to start of inward cut
    path.arcToPoint(
      Offset(0, size.height * 0.36),
      radius: Radius.circular(size.width * 0.1),
      clockwise: false, // Counter-clockwise for inward effect
    );

    // Complete the path
    path.lineTo(0, size.height * 0.2);
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
