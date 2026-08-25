import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/shimmer_loading.dart';

class AssignedPatientDetailsShimmer extends StatelessWidget {
  const AssignedPatientDetailsShimmer({super.key});

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
          _PatientCardSkeleton(),
          SizedBox(height: AppDimensions.lg),
          _SectionSkeleton(lines: 3),
          SizedBox(height: AppDimensions.lg),
          _SectionSkeleton(lines: 3),
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

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

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
      child: child,
    );
  }
}

class _PatientCardSkeleton extends StatelessWidget {
  const _PatientCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _CardShell(
      child: Column(
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
          Row(
            children: [
              Expanded(child: ShimmerBox(height: 34)),
              SizedBox(width: AppDimensions.lg),
              Expanded(child: ShimmerBox(height: 34)),
            ],
          ),
          SizedBox(height: AppDimensions.md),
          Row(
            children: [
              Expanded(child: ShimmerBox(height: 34)),
              SizedBox(width: AppDimensions.lg),
              Expanded(child: ShimmerBox(height: 34)),
            ],
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

class _SectionSkeleton extends StatelessWidget {
  const _SectionSkeleton({required this.lines});

  final int lines;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 150, height: 16),
          const SizedBox(height: AppDimensions.md),
          for (var i = 0; i < lines; i++) ...[
            if (i > 0) const SizedBox(height: AppDimensions.sm),
            ShimmerBox(width: i.isEven ? double.infinity : 220, height: 13),
          ],
        ],
      ),
    );
  }
}