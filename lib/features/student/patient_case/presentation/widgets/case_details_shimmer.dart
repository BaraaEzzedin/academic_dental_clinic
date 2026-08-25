import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/shimmer_loading.dart';

/// Skeleton placeholder shown while the case details are loading. Mirrors the
/// real [CaseDetailsBody] layout: header card, treatment plan, diagnostic
/// media, sessions region and supervisor notes.
class CaseDetailsShimmer extends StatelessWidget {
  const CaseDetailsShimmer({super.key});

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
          _HeaderSkeleton(),
          SizedBox(height: AppDimensions.lg),
          _SectionSkeleton(lines: 3),
          SizedBox(height: AppDimensions.lg),
          _MediaSkeleton(),
          SizedBox(height: AppDimensions.lg),
          _SectionSkeleton(lines: 2),
          SizedBox(height: AppDimensions.lg),
          _SectionSkeleton(lines: 2),
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

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerBox(width: 52, height: 52, borderRadius: 26),
              SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 160, height: 18),
                    SizedBox(height: AppDimensions.sm),
                    ShimmerBox(
                      width: 110,
                      height: 24,
                      borderRadius: AppDimensions.radiusXl,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.lg),
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

class _SectionSkeleton extends StatelessWidget {
  const _SectionSkeleton({required this.lines});

  final int lines;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 140, height: 16),
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

class _MediaSkeleton extends StatelessWidget {
  const _MediaSkeleton();

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 90, height: 16),
          const SizedBox(height: AppDimensions.md),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: 3,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppDimensions.md),
              itemBuilder: (_, _) => const SizedBox(
                width: 200,
                child: ShimmerBox(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: AppDimensions.radiusMd,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
