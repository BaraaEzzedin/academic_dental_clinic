import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/progress_phase.dart';
import '../models/session.dart';
import 'progress_timeline_section.dart';
import 'timeline_phase_item.dart';

class ProgressTimelineCard extends StatelessWidget {
  const ProgressTimelineCard({
    super.key,
    required this.sessions,
    this.onViewSessions,
  });

  /// The treatment sessions rendered as timeline phases (same data as the
  /// Sessions screen).
  final List<Session> sessions;

  /// When `null` the "View Sessions" affordances are hidden (read-only states).
  final VoidCallback? onViewSessions;

  @override
  Widget build(BuildContext context) {
    final phases = sessions.map(_toPhase).toList(growable: false);
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

  ProgressPhase _toPhase(Session session) {
    // SessionStatus and PhaseStatus share the same backend vocabulary.
    final status = switch (session.status) {
      SessionStatus.active => PhaseStatus.active,
      SessionStatus.upcoming => PhaseStatus.upcoming,
      SessionStatus.completed => PhaseStatus.completed,
    };
    return ProgressPhase(
      title: session.title,
      date: session.date,
      status: status,
    );
  }
}
