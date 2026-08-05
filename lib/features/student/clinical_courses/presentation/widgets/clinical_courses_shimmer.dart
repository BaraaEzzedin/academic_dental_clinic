import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/shimmer_loading.dart';
import 'clinical_course_item.dart';

/// Loading skeleton for the clinical courses list: circular avatar placeholders
/// with a short name line beneath, matching the final layout.
class ClinicalCoursesShimmer extends StatelessWidget {
  const ClinicalCoursesShimmer({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SizedBox(
        height: ClinicalCoursesSectionMetrics.listHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          separatorBuilder: (context, index) =>
              const SizedBox(width: AppDimensions.md),
          itemBuilder: (context, index) => const _ItemSkeleton(),
        ),
      ),
    );
  }
}

class _ItemSkeleton extends StatelessWidget {
  const _ItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ClinicalCourseItem.itemWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          ShimmerBox(
            width: ClinicalCourseItem.avatarSize,
            height: ClinicalCourseItem.avatarSize,
            borderRadius: ClinicalCourseItem.avatarSize / 2,
          ),
          SizedBox(height: AppDimensions.md),
          ShimmerBox(width: 56, height: 11),
          //SizedBox(height: AppDimensions.xs),
          //ShimmerBox(width: 38, height: 11),
        ],
      ),
    );
  }
}

/// Shared sizing so the section, list and shimmer stay in lockstep.
class ClinicalCoursesSectionMetrics {
  ClinicalCoursesSectionMetrics._();
  /// Height that fits the avatar plus a two-line course name.
   static const double listHeight =
       ClinicalCourseItem.avatarSize + AppDimensions.sm + 34;
}