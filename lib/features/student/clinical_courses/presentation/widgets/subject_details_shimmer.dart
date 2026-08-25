import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/shimmer_loading.dart';

/// Loading skeleton for the Subject Details screen. Mirrors the real body:
/// a header card, the overall-progress card, then the "Procedure Progress"
/// and "Related Cases" sections.
class SubjectDetailsShimmer extends StatelessWidget {
  const SubjectDetailsShimmer({super.key});

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
          _HeaderCardSkeleton(),
          SizedBox(height: AppDimensions.lg),
          _OverallProgressSkeleton(),
          SizedBox(height: AppDimensions.lg),
          _TitleSkeleton(),
          SizedBox(height: AppDimensions.md),
          _ProcedureCardSkeleton(),
          SizedBox(height: AppDimensions.md),
          _ProcedureCardSkeleton(),
          SizedBox(height: AppDimensions.md),
          _ProcedureCardSkeleton(),
          SizedBox(height: AppDimensions.lg),
          _TitleSkeleton(),
          SizedBox(height: AppDimensions.md),
          _CaseCardSkeleton(),
          SizedBox(height: AppDimensions.md),
          _CaseCardSkeleton(),
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

class _HeaderCardSkeleton extends StatelessWidget {
  const _HeaderCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _CardShell(
      child: Row(
        children: [
          ShimmerBox(width: 52, height: 52, borderRadius: AppDimensions.radiusMd),
          SizedBox(width: AppDimensions.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 160, height: 18),
                SizedBox(height: AppDimensions.sm),
                ShimmerBox(width: 100, height: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverallProgressSkeleton extends StatelessWidget {
  const _OverallProgressSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 140, height: 16),
          SizedBox(height: AppDimensions.md),
          ShimmerBox(
            width: double.infinity,
            height: 12,
            borderRadius: AppDimensions.radiusXl,
          ),
          SizedBox(height: AppDimensions.md),
          Row(
            children: [
              Expanded(child: ShimmerBox(height: 34)),
              SizedBox(width: AppDimensions.lg),
              Expanded(child: ShimmerBox(height: 34)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TitleSkeleton extends StatelessWidget {
  const _TitleSkeleton();

  @override
  Widget build(BuildContext context) {
    return const ShimmerBox(width: 150, height: 16);
  }
}

class _ProcedureCardSkeleton extends StatelessWidget {
  const _ProcedureCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: ShimmerBox(height: 15)),
              SizedBox(width: AppDimensions.lg),
              ShimmerBox(width: 40, height: 15),
            ],
          ),
          SizedBox(height: AppDimensions.md),
          ShimmerBox(
            width: double.infinity,
            height: 10,
            borderRadius: AppDimensions.radiusXl,
          ),
        ],
      ),
    );
  }
}

class _CaseCardSkeleton extends StatelessWidget {
  const _CaseCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _CardShell(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 150, height: 15),
                SizedBox(height: AppDimensions.sm),
                ShimmerBox(width: 90, height: 12),
              ],
            ),
          ),
          SizedBox(width: AppDimensions.lg),
          ShimmerBox(
            width: 72,
            height: 26,
            borderRadius: AppDimensions.radiusXl,
          ),
        ],
      ),
    );
  }
}
