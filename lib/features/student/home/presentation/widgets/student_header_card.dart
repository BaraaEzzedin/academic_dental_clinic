import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/student_info.dart';

/// The Home screen's opening section: a welcoming student identity card.
///
/// Styled with a barely-there teal gradient (composited over white so it stays
/// light on any background), soft rounded corners, a gentle shadow and a faint
/// decorative circle — a calm, premium "welcome back" feel. It answers, at a
/// glance, who the student is and which year they are in — deliberately *not* a
/// statistic/dashboard tile.
class StudentHeaderCard extends StatelessWidget {
  const StudentHeaderCard({super.key, required this.info});

  final StudentInfo info;

  // Near-white tints: the theme colors laid over white at a low opacity, kept
  // opaque so the card reads the same regardless of the page behind it.
  static final Color _gradientTop =
      Color.alphaBlend(AppColors.primary.withValues(alpha: 0.06), AppColors.white);
  static final Color _gradientBottom = Color.alphaBlend(
      AppColors.secondary.withValues(alpha: 0.09), AppColors.white);

  @override
  Widget build(BuildContext context) {
    final studyYear = info.studyYear.trim();
    final academicYear = info.academicYear.trim();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_gradientTop, _gradientBottom],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        child: Stack(
          children: [
            // Faint abstract accent — very low opacity, purely decorative.
            Positioned(
              top: -44,
              right: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.xl),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.logoBorder,
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
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
            ),
          ],
        ),
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
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
      ),
      child: Text(label, style: AppTextStyles.studentCardStudyYear),
    );
  }
}