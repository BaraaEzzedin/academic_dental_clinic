import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/student_dashboard_entity.dart';
import '../utils/dashboard_case_status_ui.dart';
import 'dashboard_section.dart';

/// Section 4 — distribution of cases across their clinical statuses, as small
/// colored status chips. Colors reuse the app-wide status palette.
class CasesOverviewCard extends StatelessWidget {
  const CasesOverviewCard({super.key, required this.stats});

  final DashboardStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final byStatus = stats.casesByStatus;
    // Show the known statuses in a consistent order, then any extra keys.
    final keys = <String>[
      ...DashboardCaseStatusUi.order.where(byStatus.containsKey),
      ...byStatus.keys.where((k) => !DashboardCaseStatusUi.order.contains(k)),
    ];

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardSectionTitle('Cases Overview'),
          const SizedBox(height: AppDimensions.lg),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: [
              for (final key in keys)
                _StatusChip(
                  label: DashboardCaseStatusUi.label(key),
                  count: byStatus[key] ?? 0,
                  color: DashboardCaseStatusUi.color(key),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          Text(
            label,
            style: AppTextStyles.scheduleMeta.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
