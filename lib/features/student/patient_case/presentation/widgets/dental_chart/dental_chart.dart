import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/tooth.dart';
import 'dental_chart_theme.dart';
import 'tooth_painter.dart';

// Interactive dental chart (odontogram): FDI numbering, anatomical arch
// layout, clinical status visualization, per-tooth procedure markers.
class DentalChart extends StatelessWidget {
  const DentalChart({
    super.key,
    this.selected = const {},
    this.records = const {},
    this.statusOverrides = const {},
    this.onToothTap,
    this.onToothLongPress,
    this.theme = const DentalChartTheme(),
    this.overlayBuilder,
    this.showQuadrantLabels = true,
    this.showProcedureMarkers = true,
    this.archGap = 34,
  });

  /// FDI numbers currently selected (multi-select is just a bigger set).
  final Set<int> selected;

  /// Clinical record per FDI number. Drives status colors, the extraction
  /// visualization, and the subtle procedure markers.
  final Map<int, ToothRecord> records;

  /// Optional manual status override per FDI (wins over [records]).
  final Map<int, ToothStatus> statusOverrides;

  final ValueChanged<int>? onToothTap;
  final ValueChanged<int>? onToothLongPress;
  final DentalChartTheme theme;

  /// Hook for extra layers: badges, diagnostic markers, comment dots…
  final Widget Function(BuildContext context, ToothInfo info)? overlayBuilder;

  final bool showQuadrantLabels;

  /// Draw small colored ticks on the crown for each recorded procedure.
  final bool showProcedureMarkers;

  /// Vertical breathing room between the two arches.
  final double archGap;

  static const upperFdi = [
    18, 17, 16, 15, 14, 13, 12, 11, 21, 22, 23, 24, 25, 26, 27, 28,
  ];
  static const lowerFdi = [
    48, 47, 46, 45, 44, 43, 42, 41, 31, 32, 33, 34, 35, 36, 37, 38,
  ];

  ToothStatus statusOf(int fdi) =>
      statusOverrides[fdi] ?? records[fdi]?.status ?? ToothStatus.healthy;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final tooth = (w / 8.6).clamp(38.0, 56.0);
      final geo = _ArchGeometry(width: w, toothSize: tooth);
      final archH = geo.archHeight;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: w,
            height: archH,
            child: _Arch(
                isUpper: true, fdiOrder: upperFdi, geometry: geo, chart: this),
          ),
          SizedBox(
            height: archGap,
            width: w,
            child: _MidlineDivider(theme: theme, showLabels: showQuadrantLabels),
          ),
          SizedBox(
            width: w,
            height: archH,
            child: _Arch(
                isUpper: false, fdiOrder: lowerFdi, geometry: geo, chart: this),
          ),
        ],
      );
    });
  }
}

class _MidlineDivider extends StatelessWidget {
  const _MidlineDivider({required this.theme, required this.showLabels});
  final DentalChartTheme theme;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: theme.label,
    );
    return Row(
      children: [
        const SizedBox(width: 4),
        if (showLabels) Text('R', style: style),
        const SizedBox(width: 10),
        Expanded(child: _DashedLine(color: theme.midline)),
        const SizedBox(width: 10),
        if (showLabels) Text('L', style: style),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
      size: const Size(double.infinity, 1), painter: _DashPainter(color));
}

class _DashPainter extends CustomPainter {
  _DashPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dash = 5.0, gap = 5.0;
    double x = 0;
    final y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(
          Offset(x, y), Offset(math.min(x + dash, size.width), y), p);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) => old.color != color;
}

// Arch layout — teeth on an elliptical curve, spaced by crown width.
class _ArchGeometry {
  _ArchGeometry({required this.width, required this.toothSize}) {
    const half = [10.4, 10.0, 10.8, 7.0, 7.2, 7.8, 6.6, 8.6]; // 8..1
    final widths = [...half, ...half.reversed];
    final total = widths.fold<double>(0, (a, b) => a + b);

    double acc = 0;
    for (final wd in widths) {
      _fractions.add((acc + wd / 2) / total);
      _relWidths.add(wd / total);
      acc += wd;
    }

    a = width / 2 - toothSize * 0.62 - 18; // 18 px reserved for side labels
    b = a * 1.04;
    _buildArcTable();
  }

  final double width;
  final double toothSize;
  late final double a, b;

  static const double phiMax = 82 * math.pi / 180;
  static const int _samples = 200;

  final List<double> _fractions = [];
  final List<double> _relWidths = [];
  final List<double> _arcCum = [];

  double get archHeight => b + toothSize * 1.6;

  void _buildArcTable() {
    double len = 0;
    Offset prev = _raw(0);
    _arcCum.add(0);
    for (int i = 1; i <= _samples; i++) {
      final p = _raw(i / _samples);
      len += (p - prev).distance;
      _arcCum.add(len);
      prev = p;
    }
  }

  Offset _raw(double u) {
    final phi = -phiMax + 2 * phiMax * u;
    return Offset(a * math.sin(phi), -b * math.cos(phi));
  }

  double _uForFraction(double t) {
    final target = t * _arcCum.last;
    int lo = 0, hi = _samples;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      if (_arcCum[mid] < target) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    if (lo == 0) return 0;
    final seg = _arcCum[lo] - _arcCum[lo - 1];
    final frac = seg == 0 ? 0.0 : (target - _arcCum[lo - 1]) / seg;
    return (lo - 1 + frac) / _samples;
  }

  ({Offset center, double rotation, double scale, Offset labelCenter}) slot(
    int index, {
    required bool isUpper,
  }) {
    final u = _uForFraction(_fractions[index]);
    final raw = _raw(u);

    final origin =
        Offset(width / 2, isUpper ? b + toothSize * 0.9 : toothSize * 0.6);
    final p = isUpper ? raw : Offset(raw.dx, -raw.dy);
    final center = origin + p;

    final out = p / p.distance;
    final rotation = math.atan2(out.dy, out.dx) + math.pi / 2;
    final scale = (_relWidths[index] * 16 * 0.92).clamp(0.78, 1.18);
    final labelCenter = center + out * (toothSize * 0.7);
    return (
      center: center,
      rotation: rotation,
      scale: scale,
      labelCenter: labelCenter
    );
  }
}

class _Arch extends StatelessWidget {
  const _Arch({
    required this.isUpper,
    required this.fdiOrder,
    required this.geometry,
    required this.chart,
  });

  final bool isUpper;
  final List<int> fdiOrder;
  final _ArchGeometry geometry;
  final DentalChart chart;

  @override
  Widget build(BuildContext context) {
    final t = chart.theme;
    final tooth = geometry.toothSize;
    final children = <Widget>[];

    if (chart.showQuadrantLabels) {
      final q =
          isUpper ? ('Q1 · Right', 'Q2 · Left') : ('Q4 · Right', 'Q3 · Left');
      final y = isUpper ? 0.0 : geometry.archHeight - 18;
      children.add(
          Positioned(left: 8, top: y, child: _QuadrantTag(text: q.$1, theme: t)));
      children.add(Positioned(
          right: 8, top: y, child: _QuadrantTag(text: q.$2, theme: t)));
    }

    for (int i = 0; i < fdiOrder.length; i++) {
      final fdi = fdiOrder[i];
      final s = geometry.slot(i, isUpper: isUpper);
      final size = tooth * s.scale;
      final record = chart.records[fdi];
      final info = ToothInfo(
        fdi: fdi,
        type: toothTypeOf(fdi),
        status: chart.statusOf(fdi),
        selected: chart.selected.contains(fdi),
        isUpper: isUpper,
        record: record,
      );

      // Marker colors for up to 4 most recent procedures (extraction shown
      // by the silhouette itself, so it doesn't need a tick).
      final ticks = !chart.showProcedureMarkers || record == null
          ? const <Color>[]
          : record.chronological
              .where((p) => p.type != ProcedureType.extraction)
              .take(4)
              .map((p) => p.type.markerColor)
              .toList();

      children.add(Positioned(
        left: s.labelCenter.dx - 14,
        top: s.labelCenter.dy - 9,
        child: IgnorePointer(
          child: SizedBox(
            width: 28,
            height: 18,
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1,
                  fontWeight:
                      info.selected ? FontWeight.w700 : FontWeight.w500,
                  color: info.selected ? t.primary : t.label,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
                child: Text('$fdi'),
              ),
            ),
          ),
        ),
      ));

      final hit = math.max(size + 10, 44.0);
      children.add(Positioned(
        left: s.center.dx - hit / 2,
        top: s.center.dy - hit / 2,
        width: hit,
        height: hit,
        child: _ToothWidget(
          info: info,
          theme: t,
          size: size,
          rotation: s.rotation,
          tickColors: ticks,
          onTap: chart.onToothTap == null ? null : () => chart.onToothTap!(fdi),
          onLongPress: chart.onToothLongPress == null
              ? null
              : () => chart.onToothLongPress!(fdi),
        ),
      ));

      final overlay = chart.overlayBuilder?.call(context, info);
      if (overlay != null) {
        children.add(Positioned(
          left: s.center.dx - hit / 2,
          top: s.center.dy - hit / 2,
          width: hit,
          height: hit,
          child: IgnorePointer(child: Center(child: overlay)),
        ));
      }
    }

    return Stack(clipBehavior: Clip.none, children: children);
  }
}

class _QuadrantTag extends StatelessWidget {
  const _QuadrantTag({required this.text, required this.theme});
  final String text;
  final DentalChartTheme theme;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FA),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFE4EAF1)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
            color: theme.label,
          ),
        ),
      );
}

class _ToothWidget extends StatefulWidget {
  const _ToothWidget({
    required this.info,
    required this.theme,
    required this.size,
    required this.rotation,
    required this.tickColors,
    this.onTap,
    this.onLongPress,
  });

  final ToothInfo info;
  final DentalChartTheme theme;
  final double size;
  final double rotation;
  final List<Color> tickColors;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  State<_ToothWidget> createState() => _ToothWidgetState();
}

class _ToothWidgetState extends State<_ToothWidget> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    final t = widget.theme;
    final selected = info.selected;
    final scale = _pressed ? 0.92 : (selected ? 1.08 : 1.0);

    return Semantics(
      button: true,
      selected: selected,
      label: 'Tooth ${info.fdi}, ${t.statusLabel(info.status)}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Center(
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutBack,
            child: Transform.rotate(
              angle: widget.rotation,
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: selected ? 1 : 0),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                builder: (context, sel, _) => CustomPaint(
                  size: Size.square(widget.size),
                  painter: ToothPainter(
                    type: info.type,
                    status: info.status,
                    selection: sel,
                    theme: t,
                    tickColors: widget.tickColors,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}