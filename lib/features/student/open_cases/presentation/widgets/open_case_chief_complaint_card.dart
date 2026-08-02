import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../patient_case/presentation/widgets/progress_timeline_section.dart';


class OpenCaseChiefComplaintCard extends StatelessWidget {
  const OpenCaseChiefComplaintCard({super.key, required this.complaint});

  final String complaint;

  @override
  Widget build(BuildContext context) {
    final text = complaint.trim();
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Chief Complaint'),
          const SizedBox(height: AppDimensions.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.caseChipBackground,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Text(
              text.isEmpty ? 'No chief complaint recorded.' : text,
              style: AppTextStyles.noteMessage.copyWith(
                color: text.isEmpty
                    ? AppColors.textHint
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}