import 'package:flutter/material.dart';
import 'dart:math';

class DashedUnderlinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  DashedUnderlinePainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashWidth = 6,
    this.dashSpace = 4,
    this.radius = 12,
    this.top = false,
    this.bottom = true,
    this.left = false,
    this.right = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();

    final r =  top== false? 0.0: radius;
    final w = size.width;
    final h = size.height;

    /// TOP
    if (top) {
      path.moveTo(r, 0);
      path.lineTo(w - r, 0);
      path.arcToPoint(Offset(w, r), radius: Radius.circular(r));
    }

    /// RIGHT
    if (right) {
      path.moveTo(w, r);
      path.lineTo(w, h - r);
      path.arcToPoint(Offset(w - r, h), radius: Radius.circular(r));
    }

    /// BOTTOM
    if (bottom) {
      path.moveTo(w - r, h);
      path.lineTo(r, h);
      path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r));
    }

    /// LEFT
    if (left) {
      path.moveTo(0, h - r);
      path.lineTo(0, r);
      path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));
    }

    final dashed = _createDashedPath(path);
    canvas.drawPath(dashed, paint);
  }

  Path _createDashedPath(Path source) {
    final Path dest = Path();

    for (final metric in source.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final next = min(distance + dashWidth, metric.length);
        dest.addPath(metric.extractPath(distance, next), Offset.zero);
        distance += dashWidth + dashSpace;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
