import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/shimmer_loading.dart';

class SubjectFilterShimmer extends StatelessWidget {
  const SubjectFilterShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ShimmerLoading(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontalPadding,
          ),
          itemCount: itemCount,
          separatorBuilder: (context, index) =>
              const SizedBox(width: AppDimensions.sm),
          itemBuilder: (context, index) => const ShimmerBox(
            width: 104,
            height: 40,
            borderRadius: AppDimensions.radiusXl,
          ),
        ),
      ),
    );
  }
}

class OpenCaseListShimmer extends StatelessWidget {
  const OpenCaseListShimmer({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenHorizontalPadding,
          vertical: AppDimensions.lg,
        ),
        itemCount: itemCount,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppDimensions.lg),
        itemBuilder: (context, index) => const _OpenCaseCardSkeleton(),
      ),
    );
  }
}

class _OpenCaseCardSkeleton extends StatelessWidget {
  const _OpenCaseCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ShimmerBox(width: 5, height: double.infinity, borderRadius: 0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerBox(width: 150, height: 16),
                    SizedBox(height: AppDimensions.sm),
                    ShimmerBox(width: 110, height: 12),
                    SizedBox(height: AppDimensions.md),
                    ShimmerBox(
                      width: double.infinity,
                      height: 52,
                      borderRadius: AppDimensions.radiusMd,
                    ),
                    SizedBox(height: AppDimensions.md),
                    ShimmerBox(width: 170, height: 12),
                    SizedBox(height: AppDimensions.md),
                    ShimmerBox(
                      width: double.infinity,
                      height: 44,
                      borderRadius: AppDimensions.radiusMd,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}