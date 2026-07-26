import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_text_style.dart';


class SessionSummaryNote extends StatelessWidget {
  const SessionSummaryNote({super.key, required this.note});

  final String? note;

  @override
  Widget build(BuildContext context) {
    final trimmed = note?.trim();
    final isEmpty = trimmed == null || trimmed.isEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Text(
        isEmpty
            ? 'No clinical notes were recorded for this session.'
            : trimmed,
        style: isEmpty ? AppTextStyles.hint : AppTextStyles.noteMessage,
      ),
    );
  }
}