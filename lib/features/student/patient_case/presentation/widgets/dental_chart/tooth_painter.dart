import 'package:flutter/material.dart';
import '../../models/tooth.dart';
import 'dental_chart_theme.dart';

// Anatomical occlusal-view crowns. Public so the detail sheet can reuse it
// for the mini tooth preview.
class ToothPainter extends CustomPainter {
  ToothPainter({
    required this.type,
    required this.status,
    required this.theme,
    this.selection = 0,
    this.tickColors = const [],
  });

  final ToothType type;
  final ToothStatus status;
  final double selection; // 0..1 animated
  final DentalChartTheme theme;
  final List<Color> tickColors;

  @override
  void paint(Canvas canvas, Size size) {
    final outline = _outlinePath(type, size);
    final grooves = _groovePath(type, size);

    final extracted = status == ToothStatus.extracted;
    final statusC = theme.statusColor(status);
    final hasStatus = status != ToothStatus.healthy;

    canvas.drawShadow(outline.shift(const Offset(0, 1)),
        Colors.black.withValues(alpha: extracted ? 0.18 : 0.35), 2.5, true);

    if (selection > 0) {
      final glow = Paint()
        ..color = theme.primary.withValues(alpha: 0.35 * selection)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6;
      canvas.drawPath(outline, glow);
    }

    // Enamel body. Extracted teeth get a stronger muted-red wash so the
    // silhouette itself reads as "missing" while keeping the arch intact.
    final tint = selection > 0
        ? Color.lerp(Colors.transparent, theme.primary, 0.16 * selection)!
        : extracted
            ? statusC.withValues(alpha: 0.26)
            : (hasStatus ? statusC.withValues(alpha: 0.15) : Colors.transparent);

    final body = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.alphaBlend(tint, theme.enamelLight),
          Color.alphaBlend(tint, theme.enamelDark),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(outline, body);

    if (!extracted) {
      final hi = Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.25, -0.35),
          radius: 0.9,
          colors: [
            Colors.white.withValues(alpha: 0.55),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(Offset.zero & size);
      canvas.save();
      canvas.clipPath(outline);
      canvas.drawRect(Offset.zero & size, hi);
      canvas.restore();
    }

    // Anatomical grooves — faded on extracted teeth.
    final groovePaint = Paint()
      ..color = (hasStatus ? statusC : theme.groove)
          .withValues(alpha: extracted ? 0.25 : (hasStatus ? 0.45 : 0.9))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.028
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(grooves, groovePaint);

    // Subtle diagonal clinical cross for extracted / missing teeth.
    if (extracted) {
      canvas.save();
      canvas.clipPath(outline);
      final cross = Paint()
        ..color = statusC.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.055
        ..strokeCap = StrokeCap.round;
      final w = size.width, h = size.height;
      canvas.drawLine(Offset(w * 0.2, h * 0.2), Offset(w * 0.8, h * 0.8), cross);
      canvas.drawLine(Offset(w * 0.8, h * 0.2), Offset(w * 0.2, h * 0.8), cross);
      canvas.restore();
    }

    // Procedure tick markers along the cervical edge — one per procedure,
    // colored by treatment family. Kept tiny so the chart stays clean.
    if (tickColors.isNotEmpty && !extracted) {
      final n = tickColors.length;
      final tickW = size.width * 0.11;
      final tickH = size.width * 0.05;
      final gap = size.width * 0.035;
      final totalW = n * tickW + (n - 1) * gap;
      var x = (size.width - totalW) / 2;
      final y = size.height * 0.76;
      canvas.save();
      canvas.clipPath(outline);
      for (final c in tickColors) {
        final r = RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, tickW, tickH), Radius.circular(tickH / 2));
        canvas.drawRRect(r, Paint()..color = c);
        x += tickW + gap;
      }
      canvas.restore();
    }

    // Outline.
    final strokeC = selection > 0
        ? Color.lerp(hasStatus ? statusC : theme.outline, theme.primary, selection)!
        : (hasStatus ? statusC : theme.outline);
    final stroke = Paint()
      ..color = strokeC
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * (0.035 + 0.03 * selection) +
          (hasStatus ? size.width * 0.012 : 0);
    canvas.drawPath(outline, stroke);
  }

  static Path _outlinePath(ToothType t, Size s) {
    final w = s.width, h = s.height;
    Offset o(double x, double y) => Offset(x * w, y * h);

    switch (t) {
      case ToothType.molar:
        return Path()
          ..moveTo(o(.5, .06).dx, o(.5, .06).dy)
          ..cubicTo(o(.72, .04).dx, o(.72, .04).dy, o(.94, .16).dx, o(.94, .16).dy,
              o(.93, .38).dx, o(.93, .38).dy)
          ..cubicTo(o(.925, .5).dx, o(.925, .5).dy, o(.94, .6).dx, o(.94, .6).dy,
              o(.92, .68).dx, o(.92, .68).dy)
          ..cubicTo(o(.88, .9).dx, o(.88, .9).dy, o(.68, .97).dx, o(.68, .97).dy,
              o(.5, .955).dx, o(.5, .955).dy)
          ..cubicTo(o(.32, .97).dx, o(.32, .97).dy, o(.12, .9).dx, o(.12, .9).dy,
              o(.08, .68).dx, o(.08, .68).dy)
          ..cubicTo(o(.06, .6).dx, o(.06, .6).dy, o(.075, .5).dx, o(.075, .5).dy,
              o(.07, .38).dx, o(.07, .38).dy)
          ..cubicTo(o(.06, .16).dx, o(.06, .16).dy, o(.28, .04).dx, o(.28, .04).dy,
              o(.5, .06).dx, o(.5, .06).dy)
          ..close();

      case ToothType.premolar:
        return Path()
          ..moveTo(o(.5, .07).dx, o(.5, .07).dy)
          ..cubicTo(o(.78, .06).dx, o(.78, .06).dy, o(.9, .28).dx, o(.9, .28).dy,
              o(.88, .5).dx, o(.88, .5).dy)
          ..cubicTo(o(.86, .74).dx, o(.86, .74).dy, o(.74, .94).dx, o(.74, .94).dy,
              o(.5, .93).dx, o(.5, .93).dy)
          ..cubicTo(o(.26, .94).dx, o(.26, .94).dy, o(.14, .74).dx, o(.14, .74).dy,
              o(.12, .5).dx, o(.12, .5).dy)
          ..cubicTo(o(.1, .28).dx, o(.1, .28).dy, o(.22, .06).dx, o(.22, .06).dy,
              o(.5, .07).dx, o(.5, .07).dy)
          ..close();

      case ToothType.canine:
        return Path()
          ..moveTo(o(.5, .03).dx, o(.5, .03).dy)
          ..cubicTo(o(.72, .1).dx, o(.72, .1).dy, o(.88, .32).dx, o(.88, .32).dy,
              o(.86, .55).dx, o(.86, .55).dy)
          ..cubicTo(o(.84, .78).dx, o(.84, .78).dy, o(.7, .95).dx, o(.7, .95).dy,
              o(.5, .94).dx, o(.5, .94).dy)
          ..cubicTo(o(.3, .95).dx, o(.3, .95).dy, o(.16, .78).dx, o(.16, .78).dy,
              o(.14, .55).dx, o(.14, .55).dy)
          ..cubicTo(o(.12, .32).dx, o(.12, .32).dy, o(.28, .1).dx, o(.28, .1).dy,
              o(.5, .03).dx, o(.5, .03).dy)
          ..close();

      case ToothType.incisor:
        return Path()
          ..moveTo(o(.5, .1).dx, o(.5, .1).dy)
          ..cubicTo(o(.82, .08).dx, o(.82, .08).dy, o(.92, .3).dx, o(.92, .3).dy,
              o(.9, .5).dx, o(.9, .5).dy)
          ..cubicTo(o(.88, .72).dx, o(.88, .72).dy, o(.76, .9).dx, o(.76, .9).dy,
              o(.5, .9).dx, o(.5, .9).dy)
          ..cubicTo(o(.24, .9).dx, o(.24, .9).dy, o(.12, .72).dx, o(.12, .72).dy,
              o(.1, .5).dx, o(.1, .5).dy)
          ..cubicTo(o(.08, .3).dx, o(.08, .3).dy, o(.18, .08).dx, o(.18, .08).dy,
              o(.5, .1).dx, o(.5, .1).dy)
          ..close();
    }
  }

  static Path _groovePath(ToothType t, Size s) {
    final w = s.width, h = s.height;
    Offset o(double x, double y) => Offset(x * w, y * h);
    final path = Path();

    switch (t) {
      case ToothType.molar:
        path
          ..moveTo(o(.22, .5).dx, o(.22, .5).dy)
          ..cubicTo(o(.38, .44).dx, o(.38, .44).dy, o(.62, .56).dx, o(.62, .56).dy,
              o(.78, .5).dx, o(.78, .5).dy)
          ..moveTo(o(.38, .48).dx, o(.38, .48).dy)
          ..lineTo(o(.34, .28).dx, o(.34, .28).dy)
          ..moveTo(o(.62, .52).dx, o(.62, .52).dy)
          ..lineTo(o(.66, .74).dx, o(.66, .74).dy);
      case ToothType.premolar:
        path
          ..moveTo(o(.28, .5).dx, o(.28, .5).dy)
          ..cubicTo(o(.42, .46).dx, o(.42, .46).dy, o(.58, .54).dx, o(.58, .54).dy,
              o(.72, .5).dx, o(.72, .5).dy);
      case ToothType.canine:
        path
          ..moveTo(o(.5, .22).dx, o(.5, .22).dy)
          ..lineTo(o(.5, .58).dx, o(.5, .58).dy);
      case ToothType.incisor:
        path
          ..moveTo(o(.26, .5).dx, o(.26, .5).dy)
          ..cubicTo(o(.4, .47).dx, o(.4, .47).dy, o(.6, .53).dx, o(.6, .53).dy,
              o(.74, .5).dx, o(.74, .5).dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(ToothPainter old) =>
      old.type != type ||
      old.status != status ||
      old.selection != selection ||
      old.theme != theme ||
      !identical(old.tickColors, tickColors);
}