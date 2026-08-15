import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/shimmer_loading.dart';

class NotificationsListShimmer extends StatelessWidget {
  const NotificationsListShimmer({super.key, this.itemCount = 6});

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
            const SizedBox(height: AppDimensions.md),
        itemBuilder: (context, index) => const _NotificationSkeleton(),
      ),
    );
  }
}

class _NotificationSkeleton extends StatelessWidget {
  const _NotificationSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ShimmerBox(width: 42, height: 42, borderRadius: 21),
          SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 140, height: 15),
                SizedBox(height: AppDimensions.sm),
                ShimmerBox(width: double.infinity, height: 12),
                SizedBox(height: AppDimensions.xs),
                ShimmerBox(width: 80, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}