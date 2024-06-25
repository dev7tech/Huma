import 'dart:math';
import 'package:flutter/material.dart';

class RadialPainter extends CustomPainter {
  const RadialPainter({
    required this.menPercentage,
    required this.womenPercentage,
    required this.otherPercentage,
    required this.width,
  });

  final double menPercentage;
  final double womenPercentage;
  final double otherPercentage;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    Paint menPaint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Paint womenPaint = Paint()
      ..color = Colors.purple
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Paint otherPaint = Paint()
      ..color = Colors.green.shade400
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    double totalPercentage = menPercentage + womenPercentage + otherPercentage;

    // Check if totalPercentage is 0 to avoid division by zero
    if (totalPercentage == 0) return;

    double menSweepAngle = 2 * pi * menPercentage / totalPercentage;
    double womenSweepAngle = 2 * pi * womenPercentage / totalPercentage;
    double otherSweepAngle = 2 * pi * otherPercentage / totalPercentage;

    // Draw arcs for each gender
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      menSweepAngle,
      false,
      menPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2 + menSweepAngle,
      womenSweepAngle,
      false,
      womenPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2 + menSweepAngle + womenSweepAngle,
      otherSweepAngle,
      false,
      otherPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
