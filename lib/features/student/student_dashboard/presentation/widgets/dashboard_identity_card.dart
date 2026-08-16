import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/student_dashboard_entity.dart';

/// Section 1 — the student's academic identity. Styled as a distinctive teal
/// accent card (matching the Home identity card) so the dashboard opens with a
/// clear "who am I / what year" answer, not a profile page.
class DashboardIdentityCard extends StatelessWidget {
  const DashboardIdentityCard({super.key, required this.student});

  final DashboardStudentEntity student;

  @override
  Widget build(BuildContext context) {
    final studyYear = student.studyYear.trim();
    final academicYear = student.academicYear.trim();
    final universityId = student.universityId.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.logoBorder,
            child: Icon(
              Icons.school_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: AppDimensions.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.studentCardName,
                ),
                if (universityId.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    'University ID · $universityId',
                    style: AppTextStyles.studentCardAcademicYear,
                  ),
                ],
                if (studyYear.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.md),
                  _Pill(label: studyYear),
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

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

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
