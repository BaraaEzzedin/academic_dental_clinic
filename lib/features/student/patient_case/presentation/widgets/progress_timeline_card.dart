import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/progress_phase.dart';
import 'progress_timeline_section.dart';
import 'timeline_phase_item.dart';

class ProgressTimelineCard extends StatelessWidget {
  const ProgressTimelineCard({
    super.key,
    required this.phases,
    this.onViewSessions,
  });

  final List<ProgressPhase> phases;
  final VoidCallback? onViewSessions;

  @override
  Widget build(BuildContext context) {
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            'Progress Timeline',
            trailing: IconButton(
              onPressed: onViewSessions,
              icon: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primary,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
              tooltip: 'View sessions',
            ),
          ),
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
              onPressed: onViewSessions,
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
              child: const Text('View Sessions'),
            ),
          ),
        ],
      ),
    );
  }
}