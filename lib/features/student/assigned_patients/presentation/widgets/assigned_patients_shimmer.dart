import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/shimmer_loading.dart';
import 'assigned_patient_card.dart';


class AssignedPatientsShimmer extends StatelessWidget {
  const AssignedPatientsShimmer({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SizedBox(
        height: AssignedPatientCard.height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          separatorBuilder: (context, index) =>
              const SizedBox(width: AppDimensions.md),
          itemBuilder: (context, index) => const _CardSkeleton(),
        ),
      ),
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AssignedPatientCard.width,
      height: AssignedPatientCard.height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ShimmerBox(width: 5, height: double.infinity, borderRadius: 0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Expanded(child: ShimmerBox(width: 120, height: 16)),
                      SizedBox(width: AppDimensions.sm),
                      ShimmerBox(
                        width: 84,
                        height: 24,
                        borderRadius: AppDimensions.radiusXl,
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.md),
                  Expanded(
                    child: ShimmerBox(
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: AppDimensions.radiusMd,
                    ),
                  ),
                  SizedBox(height: AppDimensions.md),
                  ShimmerBox(width: 104, height: 14),
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
    );
  }
}