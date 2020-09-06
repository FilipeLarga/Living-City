import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double minHeight;
  final double minSpace;
  final double margin;
  final double dashWidth;

  DashedLinePainter(
      {@required this.color,
      this.minHeight = 6,
      this.minSpace = 4,
      this.margin = 4,
      this.dashWidth = 2});

  @override
  void paint(Canvas canvas, Size size) {
    double heightSpace = size.height - margin * 2;
    int dashCount = (heightSpace / (minHeight + minSpace)).floor();
    double height = (heightSpace - ((dashCount - 1) * minSpace)) / dashCount;

    double startY = margin;
    final paint = Paint()
      ..color = color
      ..strokeWidth = dashWidth
      ..strokeCap = StrokeCap.round;

    while (startY < size.height - margin) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + height), paint);
      startY += height + minSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
