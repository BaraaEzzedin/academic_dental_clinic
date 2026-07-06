import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle caveat(TextStyle style) => GoogleFonts.caveat(textStyle: style);
  static TextStyle manrope(TextStyle style) => GoogleFonts.manrope(textStyle: style);
  static TextStyle outFit(TextStyle style) => GoogleFonts.playfairDisplay(textStyle: style);

  static TextStyle welcome = caveat(const TextStyle(
      fontSize: 32 ,
      fontWeight: FontWeight.bold,
      color: AppColors.secondary
  ));


  static TextStyle loginText = manrope(const TextStyle(
    fontSize: 18 ,
    fontWeight: FontWeight.normal,
    color: AppColors.textDark,
  ));

  static TextStyle appDefinition = outFit( TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  ));


  static const TextStyle topBarTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const TextStyle title = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle fieldLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle input = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle hint = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );

  static const TextStyle error = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle link = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const TextStyle checkboxLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle helperText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );

  static const TextStyle dividerLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 1,
  );

  static const TextStyle otpDigit = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
}