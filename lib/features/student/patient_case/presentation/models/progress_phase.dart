import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

enum PhaseStatus {
  completed,
  inProgress,
  pending,
}

extension PhaseStatusX on PhaseStatus {
  String get label => switch (this) {
        PhaseStatus.completed => 'Completed',
        PhaseStatus.inProgress => 'In Progress',
        PhaseStatus.pending => 'Pending',
      };

  Color get color => switch (this) {
        PhaseStatus.completed => AppColors.success,
        PhaseStatus.inProgress => AppColors.primary,
        PhaseStatus.pending => AppColors.textHint,
      };

  IconData get icon => switch (this) {
        PhaseStatus.completed => Icons.check_rounded,
        PhaseStatus.inProgress => Icons.timelapse_rounded,
        PhaseStatus.pending => Icons.circle_outlined,
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