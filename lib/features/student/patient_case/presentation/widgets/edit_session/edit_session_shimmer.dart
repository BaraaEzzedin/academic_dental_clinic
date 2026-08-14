import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/widgets/shimmer_loading.dart';

/// Skeleton shown while the Edit Session sheet loads its procedures + materials.
/// Mirrors the real layout: a couple of treatment-item cards, a materials
/// field and a notes field.
class EditSessionShimmer extends StatelessWidget {
  const EditSessionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ShimmerBox(width: 150, height: 18),
            SizedBox(height: AppDimensions.lg),
            _ItemSkeleton(),
            SizedBox(height: AppDimensions.lg),
            _ItemSkeleton(),
            SizedBox(height: AppDimensions.xl),
            ShimmerBox(width: 110, height: 18),
            SizedBox(height: AppDimensions.md),
            ShimmerBox(height: 56, borderRadius: AppDimensions.radiusMd),
          ],
        ),
      ),
    );
  }
}

class _ItemSkeleton extends StatelessWidget {
  const _ItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: ShimmerBox(width: 90, height: 15)),
              SizedBox(width: AppDimensions.sm),
              ShimmerBox(width: 120, height: 13),
            ],
          ),
          SizedBox(height: AppDimensions.md),
          ShimmerBox(height: 44, borderRadius: AppDimensions.radiusMd),
        ],
      ),
    );
  }
}
