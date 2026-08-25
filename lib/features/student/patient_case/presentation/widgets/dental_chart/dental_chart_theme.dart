import 'package:flutter/material.dart';
import '../../models/tooth.dart';

// Palette + status mapping for the dental chart. Kept local to the chart
// because these are specialised clinical colors, not app-wide tokens.
class DentalChartTheme {
  const DentalChartTheme({
    this.primary = const Color(0xFF0E9384), // selection — deep clinical teal
    this.treated = const Color(0xFF2E90FA), // blue — existing treatment
    this.pending = const Color(0xFFF79009), // orange — awaiting approval
    this.approved = const Color(0xFF12B76A), // green
    this.rejected = const Color(0xFF98A2B3), // gray
    this.extracted = const Color(0xFFE5484D), // muted clinical red
    this.enamelLight = const Color(0xFFFFFFFF),
    this.enamelDark = const Color(0xFFEBF0F5),
    this.outline = const Color(0xFFC3CFDB),
    this.groove = const Color(0xFFB3C0CD),
    this.label = const Color(0xFF667085),
    this.labelStrong = const Color(0xFF101828),
    this.midline = const Color(0xFFD8DFE8),
  });

  final Color primary;
  final Color treated;
  final Color pending;
  final Color approved;
  final Color rejected;
  final Color extracted;
  final Color enamelLight;
  final Color enamelDark;
  final Color outline;
  final Color groove;
  final Color label;
  final Color labelStrong;
  final Color midline;

  Color statusColor(ToothStatus s) => switch (s) {
        ToothStatus.treated => treated,
        ToothStatus.pending => pending,
        ToothStatus.approved => approved,
        ToothStatus.rejected => rejected,
        ToothStatus.extracted => extracted,
        ToothStatus.healthy => outline,
      };

  String statusLabel(ToothStatus s) => switch (s) {
        ToothStatus.healthy => 'Healthy',
        ToothStatus.treated => 'Existing treatment',
        ToothStatus.pending => 'Pending approval',
        ToothStatus.approved => 'Approved',
        ToothStatus.rejected => 'Rejected',
        ToothStatus.extracted => 'Extracted / missing',
      };
}