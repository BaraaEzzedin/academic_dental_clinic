import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_text_style.dart';


enum PatientStatus {
  waitingApproval,
  inTreatment,
  completed,
}

extension PatientStatusX on PatientStatus {
  String get label => switch (this) {
        PatientStatus.waitingApproval => 'Waiting Approval',
        PatientStatus.inTreatment => 'In Treatment',
        PatientStatus.completed => 'Completed',
      };

  Color get color => switch (this) {
        PatientStatus.waitingApproval => AppColors.warning,
        PatientStatus.inTreatment => AppColors.primary,
        PatientStatus.completed => AppColors.success,
      };
}


class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final PatientStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.statusBadge.copyWith(color: color),
      ),
    );
  }
}