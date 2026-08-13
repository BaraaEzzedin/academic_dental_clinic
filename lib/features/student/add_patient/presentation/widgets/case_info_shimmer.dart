import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/shimmer_loading.dart';

/// Shimmer placeholder shown while the selected subject's procedures/questions
/// (its configuration) are loading in Step 2. Mirrors the shape of the loaded
/// content: the procedure/dental-chart card + the selected-procedures block.
class CaseInfoShimmer extends StatelessWidget {
  const CaseInfoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerLoading(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: double.infinity,
            height: 200,
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
        ],
      ),
    );
  }
}
