import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/progress_phase.dart';

class TimelinePhaseItem extends StatelessWidget {
  const TimelinePhaseItem({
    super.key,
    required this.phase,
    required this.isLast,
  });

  final ProgressPhase phase;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = phase.status.color;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(phase.status.icon, size: 15, color: AppColors.white),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: AppDimensions.xs),
                    color: AppColors.timelineLine,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(phase.title, style: AppTextStyles.timelinePhaseTitle),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    '${phase.date} · ${phase.status.label}',
                    style: AppTextStyles.timelinePhaseMeta,
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