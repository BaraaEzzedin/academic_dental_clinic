import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/widgets/shimmer_loading.dart';

/// Skeleton for the Session Summary procedures list while it loads.
class SessionSummaryShimmer extends StatelessWidget {
  const SessionSummaryShimmer({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 130, height: 18),
          const SizedBox(height: AppDimensions.lg),
          for (var i = 0; i < itemCount; i++) ...[
            if (i > 0) const SizedBox(height: AppDimensions.lg),
            const _ProcedureSkeleton(),
          ],
        ],
      ),
    );
  }
}

class _ProcedureSkeleton extends StatelessWidget {
  const _ProcedureSkeleton();

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
          ShimmerBox(width: 180, height: 15),
          SizedBox(height: AppDimensions.md),
          ShimmerBox(width: 90, height: 20, borderRadius: AppDimensions.radiusSm),
        ],
      ),
    );
  }
}
