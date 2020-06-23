import 'package:flutter/material.dart';
import 'dart:math';

class CircleProgress extends CustomPainter {
  final double currentProgress;

  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    double angle = 2 * pi * (currentProgress / 100);

    Rect rect = Rect.fromCircle(center: center, radius: radius);

    final gradient = SweepGradient(
        colors: [Colors.green.withOpacity(0.4), Colors.green],
        startAngle: 3 * pi / 2,
        endAngle: 7 * pi / 2,
        tileMode: TileMode.repeated);

    // final gradient = RadialGradient(
    //     colors: [Colors.green.withOpacity(0.1), Colors.green], stops: [0.0, 1]);

    //this is base circle
    Paint outerCircle = Paint()
      ..strokeWidth = 5
      ..color = Colors.grey[200]
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 5
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
        center, radius, outerCircle); // this draws main outer circle

    canvas.drawArc(rect, (-pi / 2) + (2.5 / radius), angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
