import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/student_dashboard_entity.dart';

/// Section 1 — the student's academic identity. Styled as a teal gradient card
/// (primary → secondary, matching the Home identity card) so the dashboard
/// opens with a clear "who am I / what year" answer, not a profile page.
class DashboardIdentityCard extends StatelessWidget {
  const DashboardIdentityCard({super.key, required this.student});

  final DashboardStudentEntity student;

  // Light-on-gradient variants of the shared identity styles.
  static final TextStyle _nameStyle =
      AppTextStyles.studentCardName.copyWith(color: AppColors.white);
  static const Color _mutedOnGradient = Color(0xFFCDECEC);

  @override
  Widget build(BuildContext context) {
    final studyYear = student.studyYear.trim();
    final academicYear = student.academicYear.trim();
    final universityId = student.universityId.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
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
          const Icon(
            Icons.school_rounded,
            color: AppColors.white,
            size: 24,
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _nameStyle,
                ),
                if (universityId.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    'University ID · $universityId',
                    style: AppTextStyles.studentCardAcademicYear
                        .copyWith(color: _mutedOnGradient),
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
                    style: AppTextStyles.studentCardAcademicYear
                        .copyWith(color: _mutedOnGradient),
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
        color: AppColors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: AppTextStyles.studentCardStudyYear
            .copyWith(color: AppColors.white),
      ),
    );
  }
}
