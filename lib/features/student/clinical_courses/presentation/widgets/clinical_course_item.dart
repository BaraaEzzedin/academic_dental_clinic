import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/clinical_course_entity.dart';
import '../utils/clinical_course_icon.dart';

/// A single clinical course in the home list: a circular themed avatar with the
/// course name beneath it.
///
/// Tapping is wired through [onTap] but does nothing yet — it is the entry point
/// for the upcoming Course Details feature (progress, procedures, cases,
/// supervisor).
class ClinicalCourseItem extends StatelessWidget {
  const ClinicalCourseItem({
    super.key,
    required this.course,
    this.onTap,
  });

  final ClinicalCourseEntity course;
  final VoidCallback? onTap;

  /// Diameter of the circular avatar.
  static const double avatarSize = 60;

  /// Fixed slot width so items align and names wrap consistently.
  static const double itemWidth = 78;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: itemWidth,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Avatar(icon: clinicalCourseIcon(course)),
              const SizedBox(height: AppDimensions.sm),
              Text(course.name,textAlign:TextAlign.center,maxLines: 2 , overflow: TextOverflow.ellipsis , style: AppTextStyles.clinicalCourseName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The circular avatar: a soft primary-tinted disc holding a course icon.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ClinicalCourseItem.avatarSize,
      height: ClinicalCourseItem.avatarSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.logoBorder),
      ),
      child: Icon(
        icon,
        size: 26,
        color: AppColors.primary,
      ),
    );
  }
}