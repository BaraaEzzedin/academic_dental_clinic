import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';

class ChiefComplaintBox extends StatelessWidget {
  const ChiefComplaintBox({
    super.key,
    required this.text,
    this.maxLines = 2,
  });

  final String text;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CHIEF COMPLAINT', style: AppTextStyles.caseFieldLabel),
          const SizedBox(height: AppDimensions.xs),
          Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.scheduleMeta.copyWith(height: 1.35),
          ),
        ],
      ),
    );
  }
}
