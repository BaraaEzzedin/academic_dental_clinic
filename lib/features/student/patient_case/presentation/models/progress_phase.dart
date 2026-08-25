import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

// Mirrors the backend session statuses so the timeline agrees with the
// sessions screen: `active` (current), `upcoming` (scheduled), `completed`.
enum PhaseStatus {
  active,
  upcoming,
  completed,
}

extension PhaseStatusX on PhaseStatus {
  String get label => switch (this) {
        PhaseStatus.active => 'Active',
        PhaseStatus.upcoming => 'Upcoming',
        PhaseStatus.completed => 'Completed',
      };

  Color get color => switch (this) {
        PhaseStatus.active => AppColors.primary,
        PhaseStatus.upcoming => AppColors.warning,
        PhaseStatus.completed => AppColors.success,
      };

  IconData get icon => switch (this) {
        PhaseStatus.active => Icons.play_arrow_rounded,
        PhaseStatus.upcoming => Icons.schedule_rounded,
        PhaseStatus.completed => Icons.check_rounded,
      };
}

// model for ui , edit when backend is ready
class ProgressPhase {
  const ProgressPhase({
    required this.title,
    required this.date,
    required this.status,
  });

  final String title;
  final String date;
  final PhaseStatus status;
}