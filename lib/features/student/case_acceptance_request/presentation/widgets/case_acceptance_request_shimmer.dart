import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/shimmer_loading.dart';

class CaseAcceptanceRequestShimmer extends StatelessWidget {
  const CaseAcceptanceRequestShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.screenHorizontalPadding,
          0,
          AppDimensions.screenHorizontalPadding,
          AppDimensions.xl,
        ),
        children: const [
          _SummarySkeleton(),
          SizedBox(height: AppDimensions.lg),
          ShimmerBox(
            width: double.infinity,
            height: 300,
            borderRadius: AppDimensions.radiusXl,
          ),
          SizedBox(height: AppDimensions.xl),
          ShimmerBox(width: 180, height: 18),
          SizedBox(height: AppDimensions.md),
          ShimmerBox(
            width: double.infinity,
            height: 70,
            borderRadius: AppDimensions.radiusMd,
          ),
          SizedBox(height: AppDimensions.xl),
          ShimmerBox(width: 110, height: 15),
          SizedBox(height: AppDimensions.sm),
          ShimmerBox(
            width: double.infinity,
            height: 120,
            borderRadius: AppDimensions.radiusMd,
          ),
          SizedBox(height: AppDimensions.xl),
          ShimmerBox(
            width: double.infinity,
            height: AppDimensions.buttonHeight,
            borderRadius: AppDimensions.radiusMd,
          ),
        ],
      ),
    );
  }
}

class _SummarySkeleton extends StatelessWidget {
  const _SummarySkeleton();

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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 170, height: 18),
          SizedBox(height: AppDimensions.sm),
          ShimmerBox(
            width: 120,
            height: 26,
            borderRadius: AppDimensions.radiusXl,
          ),
          SizedBox(height: AppDimensions.lg),
          ShimmerBox(
            width: double.infinity,
            height: 64,
            borderRadius: AppDimensions.radiusMd,
          ),
        ],
      ),
    );
  }
}