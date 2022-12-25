import "package:flutter/material.dart";

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    Color color = const Color.fromRGBO(25, 25, 112, 1);
    double strokeWidth = 15;
    paint.color = color;
    paint.strokeWidth = strokeWidth;

    Offset center = Offset((size.width / 2), size.width + 50);
    canvas.drawCircle(center, (size.width / 2) + 180, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
