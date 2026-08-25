import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/widgets/shimmer_loading.dart';

/// Skeleton placeholder shown while the treatment sessions are loading. Mirrors
/// the [SessionsScreen] body: a "Sessions" heading followed by timeline items
/// (a status dot, a connector line and a session card).
class SessionsShimmer extends StatelessWidget {
  const SessionsShimmer({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.screenHorizontalPadding,
          0,
          AppDimensions.screenHorizontalPadding,
          AppDimensions.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(width: 120, height: 20),
            const SizedBox(height: AppDimensions.lg),
            for (var i = 0; i < itemCount; i++)
              _SessionItemSkeleton(isLast: i == itemCount - 1),
          ],
        ),
      ),
    );
  }
}

class _SessionItemSkeleton extends StatelessWidget {
  const _SessionItemSkeleton({required this.isLast});

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const ShimmerBox(width: 32, height: 32, borderRadius: 16),
              if (!isLast)
                const Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: AppDimensions.xs),
                    child: ShimmerBox(width: 2, height: double.infinity),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimensions.lg),
              child: const _CardSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg + AppDimensions.xs),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: ShimmerBox(width: 180, height: 16)),
              SizedBox(width: AppDimensions.sm),
              ShimmerBox(
                width: 70,
                height: 20,
                borderRadius: AppDimensions.radiusSm,
              ),
            ],
          ),
          SizedBox(height: AppDimensions.md),
          Row(
            children: [
              ShimmerBox(width: 90, height: 13),
              SizedBox(width: AppDimensions.lg),
              ShimmerBox(width: 70, height: 13),
            ],
          ),
          SizedBox(height: AppDimensions.lg),
          ShimmerBox(width: double.infinity, height: 44),
        ],
      ),
    );
  }
}
