import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/progress_phase.dart';
import 'section_card.dart';
import 'timeline_phase_item.dart';

class ProgressTimelineCard extends StatelessWidget {
  const ProgressTimelineCard({
    super.key,
    required this.phases,
    this.onViewDetails,
  });

  final List<ProgressPhase> phases;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Progress Timeline'),
          const SizedBox(height: AppDimensions.lg),
          for (var i = 0; i < phases.length; i++)
            TimelinePhaseItem(
              phase: phases[i],
              isLast: i == phases.length - 1,
            ),
          const SizedBox(height: AppDimensions.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                textStyle: AppTextStyles.button,
              ),
              child: const Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }
}