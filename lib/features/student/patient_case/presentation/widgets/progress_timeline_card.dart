import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../domain/entities/timeline_entry_entity.dart';
import '../models/progress_phase.dart';
import 'progress_timeline_section.dart';
import 'timeline_phase_item.dart';

class ProgressTimelineCard extends StatelessWidget {
  const ProgressTimelineCard({
    super.key,
    required this.timeline,
    this.onViewSessions,
  });

  final List<TimelineEntryEntity> timeline;

  /// When `null` the "View Sessions" affordances are hidden (read-only states).
  final VoidCallback? onViewSessions;

  @override
  Widget build(BuildContext context) {
    final phases = timeline.map(_toPhase).toList(growable: false);
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Progress Timeline'),
          const SizedBox(height: AppDimensions.lg),
          if (phases.isEmpty)
            Text('No progress recorded yet.', style: AppTextStyles.subtitle)
          else
            for (var i = 0; i < phases.length; i++)
              TimelinePhaseItem(
                phase: phases[i],
                isLast: i == phases.length - 1,
              ),
          if (onViewSessions != null) ...[
            const SizedBox(height: AppDimensions.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onViewSessions,
                icon: const Icon(Icons.event_note_rounded, size: 18),
                label: const Text('View Sessions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: AppDimensions.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  textStyle: AppTextStyles.button,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  ProgressPhase _toPhase(TimelineEntryEntity entry) {
    final completed = (entry.rawStatus ?? '').toLowerCase() == 'completed';
    return ProgressPhase(
      title: entry.title,
      date: entry.date != null ? DateFormatter.toMediumDate(entry.date!) : '',
      status: completed ? PhaseStatus.completed : PhaseStatus.upcoming,
    );
  }
}
