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

  // ---------- Student home: identity card ----------
  // Rendered on the standard white card, matching the app's dark-on-white
  // hierarchy.
  static const TextStyle studentCardName = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.15,
  );

  static const TextStyle studentCardStudyYear = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    letterSpacing: 0.4,
  );

  static const TextStyle studentCardAcademicYear = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
  );

  // ---------- Student home ----------
  static const TextStyle homeUserName = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle homeDateLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 1.2,
  );

  static const TextStyle homeGreeting = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.15,
  );

  static const TextStyle homeSummary = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // ---------- Student home: schedule ----------
  static const TextStyle schedulePatientName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle scheduleSubject = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle scheduleMeta = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle scheduleBadge = TextStyle(
    fontSize: 10.5,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.6,
  );

  // ---------- Student: assigned patients ----------
  static const TextStyle filterChip = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle patientName = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle patientFieldLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textHint,
  );

  static const TextStyle patientFieldValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle statusBadge = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.3,
  );

  static const TextStyle viewDetailsButton = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  // ---------- Student: case details ----------
  static const TextStyle casePatientName = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle casePatientId = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textHint,
  );

  // Uppercase labels: AGE / NEXT SESSION / SUBJECT / SUPERVISOR / TARGET TOOTH
  static const TextStyle caseFieldLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textHint,
    letterSpacing: 0.6,
  );

  static const TextStyle caseFieldValue = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle caseToothLabel = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle caseProcedure = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle caseHighlightValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  static const TextStyle timelinePhaseTitle = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle sessionTitle = TextStyle(
    fontSize: 17.5,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.25,
    letterSpacing: -0.2,
  );

  // Slightly smaller than [sectionTitle] for the "Sessions" list heading.
  static const TextStyle sessionsHeading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );

  static const TextStyle timelinePhaseMeta = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle mediaCaption = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle noteReviewer = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  static const TextStyle noteTimeAgo = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textHint,
  );

  static const TextStyle noteMeta = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 0.2,
  );

  static const TextStyle noteMessage = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // ---------- Student home: clinical courses ----------
  static const TextStyle clinicalCourseName = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // ---------- Reusable stepper ----------
  // Number shown inside a step circle (completed circles show a check instead).
  static const TextStyle stepNumber = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  // Title under the current step: prominent, primary color.
  static const TextStyle stepTitleActive = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    height: 1.2,
  );

  // Title under a completed step.
  static const TextStyle stepTitleCompleted = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 1.2,
  );

  // Title under an upcoming (inactive) step.
  static const TextStyle stepTitleInactive = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textHint,
    height: 1.2,
  );
}