import 'package:flutter/material.dart';

class RectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    Color color = const Color.fromRGBO(25, 25, 112, 1);
    double strokeWidth = 300;
    paint.color = color;
    paint.strokeWidth = strokeWidth;
    Offset start = Offset(0, size.height - 120);
    Offset end = Offset(size.width, size.height - 120);
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
