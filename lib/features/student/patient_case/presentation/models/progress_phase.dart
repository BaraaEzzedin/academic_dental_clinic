import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

enum PhaseStatus {
  completed,
  upcoming,
}

extension PhaseStatusX on PhaseStatus {
  String get label => switch (this) {
        PhaseStatus.completed => 'Completed',
        PhaseStatus.upcoming => 'Upcoming',
      };

  Color get color => switch (this) {
        PhaseStatus.completed => AppColors.success,
        PhaseStatus.upcoming => AppColors.primary,
      };

  IconData get icon => switch (this) {
        PhaseStatus.completed => Icons.check_rounded,
        PhaseStatus.upcoming => Icons.play_arrow_rounded,
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