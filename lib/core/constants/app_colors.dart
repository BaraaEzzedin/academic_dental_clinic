import 'package:flutter/material.dart';


class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0E6E6E);
  static const Color primaryDark = Color(0xFF0A5B5B);
  static const Color secondary = Color(0xff024D65);

  static const Color scaffoldBackground = Color(0xFFDCF1FF);


  static const Color topBarBackground = Color(0xFFF2F8FA);
  static const Color cardBackground = Color(0xFFF2F6F9);
  static const Color cardBorder = Color(0xFFD9E1E8);

  static const Color fieldFill = Color(0xFFF7FAFC);
  static const Color fieldBorder = Color(0xFFDDE4EA);

  static const Color logoBorder = Color(0xFFBFE0EC);

  static const Color textPrimary = Color(0xFF0F2231);
  static const Color textDark = Color(0xff024D65);
  static const Color textSecondary = Color(0xFF5B6B76);
  static const Color textHint = Color(0xFF9AA7B0);

  static const Color error = Color(0xFFD32F2F);

  static const Color dividerLine = Color(0xFFDDE3E8);
  static const Color indicatorInactive = Color(0xFFCBD5DB);
  static const Color white = Color(0xFFFFFFFF);

  // ---------- Accents ----------
  // Warm coral used for the flowing accent curves in the home design.
  static const Color accentCoral = Color(0xFFF2704B);
  // Positive/completed state (e.g. "recovery complete").
  static const Color success = Color(0xFF2E9E7B);
  // Pending/attention state (e.g. "vitals pending").
  static const Color warning = Color(0xFFE0A32E);
  // Bright turquoise used for the live "ongoing" state.
  static const Color ongoing = Color(0xFF3ECAD6);

  // ---------- Schedule timeline ----------
  // The dark teal used for the timeline dots and each card's accent strip.
  static const Color timelineDot = secondary;
  // The thin connector line between dots.
  static const Color timelineLine = Color(0xFFC3D3DA);

  // ---------- Case details ----------
  static const Color caseChipBackground = Color(0xFFEAF4F6);
  static const Color mediaBackground = Color(0xFF102A33);

  // ---------- Bottom navigation ----------
  static const Color navBarBackground = Color(0xFFFFFFFF);
  static const Color navActive = primary;
  static const Color navInactive = Color(0xFF8A9AA6);
  // Soft teal wash behind the selected item's pill.
  static const Color navIndicator = Color(0xFFDDEEEC);
  static const Color navShadow = Color(0x140E6E6E);
}