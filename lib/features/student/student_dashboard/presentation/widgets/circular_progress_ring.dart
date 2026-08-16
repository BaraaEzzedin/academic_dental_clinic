import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

/// A rounded circular progress ring with arbitrary centered content, animated
/// from empty on first build. Used for the overall completion and average grade.
class CircularProgressRing extends StatelessWidget {
  const CircularProgressRing({
    super.key,
    required this.value,
    required this.child,
    this.size = 150,
    this.strokeWidth = 12,
    this.color = AppColors.primary,
    this.backgroundColor,
  });

  /// Progress fraction, 0..1.
  final double value;
  final Widget child;
  final double size;
  final double strokeWidth;
  final Color color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, animated, _) {
          return CustomPaint(
            painter: _RingPainter(
              value: animated,
              strokeWidth: strokeWidth,
              color: color,
              backgroundColor: backgroundColor ??
                  AppColors.indicatorInactive.withValues(alpha: 0.35),
            ),
            child: Center(child: child),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.value,
    required this.strokeWidth,
    required this.color,
    required this.backgroundColor,
  });

  final double value;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = backgroundColor;
    canvas.drawCircle(center, radius, track);

    if (value <= 0) return;

    final progress = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * value,
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value ||
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.backgroundColor != backgroundColor;
}
