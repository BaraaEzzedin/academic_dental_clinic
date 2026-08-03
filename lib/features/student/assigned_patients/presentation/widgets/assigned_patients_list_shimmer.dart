import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/shimmer_loading.dart';

class AssignedPatientsListShimmer extends StatelessWidget {
  const AssignedPatientsListShimmer({super.key, this.itemCount = 5});

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
        itemBuilder: (context, index) => const _ListCardSkeleton(),
      ),
    );
  }
}

class _ListCardSkeleton extends StatelessWidget {
  const _ListCardSkeleton();

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
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Expanded(child: ShimmerBox(height: 16)),
                        SizedBox(width: AppDimensions.sm),
                        ShimmerBox(width: 96, height: 24, borderRadius: 12),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),
                    const ShimmerBox(
                      width: double.infinity,
                      height: 62,
                      borderRadius: AppDimensions.radiusMd,
                    ),
                    const SizedBox(height: AppDimensions.md),
                    const ShimmerBox(width: 120, height: 13),
                    const SizedBox(height: AppDimensions.md),
                    const ShimmerBox(
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