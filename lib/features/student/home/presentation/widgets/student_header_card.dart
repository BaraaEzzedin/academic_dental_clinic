import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/student_info.dart';

/// The Home screen's opening section: a welcoming student identity card.
///
/// Styled as a distinct accent card (teal gradient, softly elevated) so it
/// stands apart from the regular light information cards while staying within
/// the app's palette. It answers, at a glance, who the student is and which
/// year they are in — it is deliberately *not* a statistic/dashboard tile.
class StudentHeaderCard extends StatelessWidget {
  const StudentHeaderCard({super.key, required this.info});

  final StudentInfo info;

  @override
  Widget build(BuildContext context) {
    final studyYear = info.studyYear.trim();
    final academicYear = info.academicYear.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // Brighter teal wash than the base primary/secondary, while keeping
          // enough contrast for the white text.
          colors: [Color(0xFF13A2A2) , AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.white.withValues(alpha: 0.18),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: AppDimensions.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.studentName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.studentCardName,
                ),
                if (studyYear.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.md),
                  _StudyYearChip(label: studyYear),
                ],
                if (academicYear.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    'Academic Year $academicYear',
                    style: AppTextStyles.studentCardAcademicYear,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The study-year pill sitting just under the name — the middle of the
/// name → study year → academic year hierarchy.
class _StudyYearChip extends StatelessWidget {
  const _StudyYearChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.22)),
      ),
      child: Text(label, style: AppTextStyles.studentCardStudyYear),
    );
  }
}