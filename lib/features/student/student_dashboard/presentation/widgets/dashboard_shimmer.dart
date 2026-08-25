import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/shimmer_loading.dart';

/// Loading skeleton for the dashboard: an identity block, a headline card and
/// a couple of section placeholders.
class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.screenHorizontalPadding,
          0,
          AppDimensions.screenHorizontalPadding,
          AppDimensions.xl,
        ),
        children: const [
          _Block(height: 120, radius: AppDimensions.radiusXl),
          SizedBox(height: AppDimensions.lg),
          _Block(height: 190),
          SizedBox(height: AppDimensions.lg),
          Row(
            children: [
              Expanded(child: _Block(height: 84)),
              SizedBox(width: AppDimensions.md),
              Expanded(child: _Block(height: 84)),
            ],
          ),
          SizedBox(height: AppDimensions.lg),
          _Block(height: 130),
          SizedBox(height: AppDimensions.lg),
          _Block(height: 130),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.height, this.radius = AppDimensions.radiusLg});

  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ShimmerBox(height: height, borderRadius: radius),
    );
  }
}
