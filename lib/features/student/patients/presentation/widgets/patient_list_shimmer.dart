import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/shimmer_loading.dart';

/// Skeleton placeholder shown while the assigned patients list is loading.
/// Mirrors the layout of [PatientCard] so the transition to real data is
/// visually smooth.
class PatientListShimmer extends StatelessWidget {
  const PatientListShimmer({super.key, this.itemCount = 5});

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
        itemBuilder: (context, index) => const _PatientCardSkeleton(),
      ),
    );
  }
}

class _PatientCardSkeleton extends StatelessWidget {
  const _PatientCardSkeleton();

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
                  children: [
                    Row(
                      children: const [
                        Expanded(child: ShimmerBox(height: 16)),
                        SizedBox(width: AppDimensions.sm),
                        ShimmerBox(width: 84, height: 22, borderRadius: 11),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),
                    const ShimmerBox(width: 140, height: 13),
                    const SizedBox(height: AppDimensions.sm),
                    const ShimmerBox(width: 90, height: 12),
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