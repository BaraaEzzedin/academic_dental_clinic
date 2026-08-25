import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../open_cases/presentation/widgets/subject_chip.dart';

class SubjectBadge extends StatelessWidget {
  const SubjectBadge({super.key, required this.subject, this.maxWidth = 160});

  final String subject;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: SubjectChip(subject: subject, maxWidth: maxWidth),
    );
  }
}