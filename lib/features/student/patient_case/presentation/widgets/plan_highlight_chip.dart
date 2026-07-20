import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/treatment_plan.dart';

class PlanHighlightChip extends StatelessWidget {
  const PlanHighlightChip({super.key, required this.highlight});

  final PlanHighlight highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            highlight.label.toUpperCase(),
            style: AppTextStyles.caseFieldLabel,
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            highlight.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caseHighlightValue,
          ),
        ],
      ),
    );
  }
}