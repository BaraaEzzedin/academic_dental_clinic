import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/shimmer_loading.dart';

/// Skeleton shown while the AI request is in flight. Its structure mirrors the
/// final result (an "AI Findings" list and a "Recommendations" block) so the
/// analysis feels like it's being generated rather than a blank wait.
class AiAnalysisShimmer extends StatelessWidget {
  const AiAnalysisShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Text('Analyzing image…', style: AppTextStyles.caseHighlightValue),
          ],
        ),
        const SizedBox(height: AppDimensions.lg),
        ShimmerLoading(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _SkeletonSectionLabel(width: 120),
              SizedBox(height: AppDimensions.md),
              _SkeletonFindingCard(),
              SizedBox(height: AppDimensions.md),
              _SkeletonFindingCard(),
              SizedBox(height: AppDimensions.md),
              _SkeletonFindingCard(),
              SizedBox(height: AppDimensions.xl),
              _SkeletonSectionLabel(width: 160),
              SizedBox(height: AppDimensions.md),
              _SkeletonParagraph(),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkeletonSectionLabel extends StatelessWidget {
  const _SkeletonSectionLabel({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(width: width, height: 16),
        const SizedBox(height: AppDimensions.sm),
        const ShimmerBox(width: double.infinity, height: 1),
      ],
    );
  }
}

class _SkeletonFindingCard extends StatelessWidget {
  const _SkeletonFindingCard();

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
          ShimmerBox(width: 14, height: 14, borderRadius: 7),
          SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 140, height: 15),
                SizedBox(height: AppDimensions.sm),
                ShimmerBox(width: 100, height: 12),
                SizedBox(height: AppDimensions.sm),
                ShimmerBox(width: double.infinity, height: 8, borderRadius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonParagraph extends StatelessWidget {
  const _SkeletonParagraph();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ShimmerBox(width: double.infinity, height: 12),
        SizedBox(height: AppDimensions.sm),
        ShimmerBox(width: 220, height: 12),
        SizedBox(height: AppDimensions.sm),
        ShimmerBox(width: 160, height: 12),
      ],
    );
  }
}
