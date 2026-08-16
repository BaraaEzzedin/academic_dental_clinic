import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

/// Presentation mapping for the raw `casesByStatus` keys: a human label and the
/// status color already used elsewhere in the app. The four core clinical
/// statuses reuse the exact colors from `PatientStatusColorX`; `open` and
/// `assigned` fall back to existing palette accents (no new status colors).
class DashboardCaseStatusUi {
  const DashboardCaseStatusUi._();

  /// Display order for the cases overview.
  static const List<String> order = [
    'open',
    'assigned',
    'diagnosis_pending_review',
    'treatment_in_progress',
    'awaiting_case_review',
    'completed',
  ];

  static String label(String key) => switch (key) {
        'open' => 'Open',
        'assigned' => 'Assigned',
        'diagnosis_pending_review' => 'Diagnosis Pending Review',
        'treatment_in_progress' => 'Treatment In Progress',
        'awaiting_case_review' => 'Awaiting Case Review',
        'completed' => 'Completed',
        _ => _humanize(key),
      };

  static Color color(String key) => switch (key) {
        // Matches PatientStatusColorX.
        'diagnosis_pending_review' => AppColors.warning,
        'treatment_in_progress' => AppColors.primary,
        'awaiting_case_review' => AppColors.secondary,
        'completed' => AppColors.success,
        // Existing palette accents for the non-clinical states.
        'assigned' => AppColors.ongoing,
        'open' => AppColors.textHint,
        _ => AppColors.textHint,
      };

  static String _humanize(String key) => key
      .split('_')
      .where((w) => w.isNotEmpty)
      .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}
