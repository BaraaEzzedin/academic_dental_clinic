import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/shimmer_loading.dart';

class TodayScheduleShimmer extends StatelessWidget {
  const TodayScheduleShimmer({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        children: [
          for (var i = 0; i < itemCount; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == itemCount - 1 ? 0 : AppDimensions.lg,
              ),
              child: const _AppointmentCardSkeleton(),
            ),
        ],
      ),
    );
  }
}

class _AppointmentCardSkeleton extends StatelessWidget {
  const _AppointmentCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        ShimmerBox(width: 22, height: 22, borderRadius: 11),
        SizedBox(width: AppDimensions.md),
        Expanded(child: _CardBody()),
      ],
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody();

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
                    Row(
                      children: [
                        Expanded(child: ShimmerBox(height: 16)),
                        SizedBox(width: AppDimensions.sm),
                        ShimmerBox(width: 74, height: 20, borderRadius: 10),
                      ],
                    ),
                    SizedBox(height: AppDimensions.md),
                    ShimmerBox(width: 150, height: 13),
                    SizedBox(height: AppDimensions.sm),
                    ShimmerBox(width: 90, height: 12),
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