import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../manager/clinical_courses/clinical_courses_cubit.dart';
import '../manager/clinical_courses/clinical_courses_state.dart';
import 'clinical_course_item.dart';
import 'clinical_courses_shimmer.dart';

/// Home section listing the student's enrolled clinical courses for the
/// semester as a horizontal, scrollable strip of course avatars.
///
/// It is an entry point for the future Course Details feature: tapping a course
/// will eventually open its progress, procedures, related cases and supervisor.
class ClinicalCoursesSection extends StatelessWidget {
  const ClinicalCoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClinicalCoursesCubit>(
      create: (_) => ClinicalCoursesCubit()..loadCourses(),
      child: BlocBuilder<ClinicalCoursesCubit, ClinicalCoursesState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clinical Courses This Semester',
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: AppDimensions.lg),
              _SectionContent(state: state),
            ],
          );
        },
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  const _SectionContent({required this.state});

  final ClinicalCoursesState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const ClinicalCoursesShimmer();
    }
    if (state.hasError) {
      return _CompactError(
        message: state.errorMessage ?? 'Failed to load clinical courses.',
        onRetry: context.read<ClinicalCoursesCubit>().loadCourses,
      );
    }
    if (state.isEmpty) {
      return const _CompactEmpty();
    }

    return SizedBox(
      height: ClinicalCoursesSectionMetrics.listHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: state.courses.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppDimensions.md),
        itemBuilder: (context, index) {
          final course = state.courses[index];
          return ClinicalCourseItem(
            course: course,
            // TODO(feature): open the Course Details screen for [course].
            onTap: () {},
          );
        },
      ),
    );
  }
}

class _CompactEmpty extends StatelessWidget {
  const _CompactEmpty();

  @override
  Widget build(BuildContext context) {
    return _MessageBox(
      icon: Icons.school_outlined,
      iconColor: AppColors.textHint,
      child: Text(
        'No clinical courses this semester yet.',
        style: AppTextStyles.subtitle,
      ),
    );
  }
}

class _CompactError extends StatelessWidget {
  const _CompactError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _MessageBox(
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.error,
      child: Row(
        children: [
          Expanded(child: Text(message, style: AppTextStyles.subtitle)),
          const SizedBox(width: AppDimensions.sm),
          TextButton.icon(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.sm,
                vertical: AppDimensions.xs,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: AppTextStyles.viewDetailsButton,
            ),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _MessageBox extends StatelessWidget {
  const _MessageBox({
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(width: AppDimensions.md),
          Expanded(child: child),
        ],
      ),
    );
  }
}