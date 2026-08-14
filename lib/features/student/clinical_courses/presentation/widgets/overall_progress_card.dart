import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../patient_case/presentation/widgets/progress_timeline_section.dart';
import '../../domain/entities/subject_details_entity.dart';
import 'subject_progress_bar.dart';

/// Prominent overall-progress card: sum(completed) / sum(required) across all
/// procedures, with a percentage and a linear progress bar.
class OverallProgressCard extends StatelessWidget {
  const OverallProgressCard({super.key, required this.details});

  final SubjectDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Overall Progress',
                  style: AppTextStyles.sectionTitle,
                ),
              ),
              Text(
                '${details.overallPercent}%',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            '${details.totalCompleted} / ${details.totalRequired} '
            'Procedures Completed',
            style: AppTextStyles.subtitle,
          ),
          const SizedBox(height: AppDimensions.md),
          SubjectProgressBar(
            value: details.overallFraction,
            color: AppColors.primary,
            height: 12,
          ),
        ],
      ),
    );
  }
}
