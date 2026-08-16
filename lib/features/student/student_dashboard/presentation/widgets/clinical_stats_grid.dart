import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/student_dashboard_entity.dart';

/// Section 3 — compact clinical-workload summary cards.
class ClinicalStatsGrid extends StatelessWidget {
  const ClinicalStatsGrid({super.key, required this.stats});

  final DashboardStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      _StatTile(
        icon: Icons.folder_shared_rounded,
        color: AppColors.primary,
        value: stats.totalCases,
        label: 'Total Cases',
      ),
      _StatTile(
        icon: Icons.play_circle_fill_rounded,
        color: AppColors.ongoing,
        value: stats.activeCases,
        label: 'Active Cases',
      ),
      _StatTile(
        icon: Icons.check_circle_rounded,
        color: AppColors.success,
        value: stats.completedCases,
        label: 'Completed Cases',
      ),
      _StatTile(
        icon: Icons.event_note_rounded,
        color: AppColors.secondary,
        value: stats.totalSessions,
        label: 'Total Sessions',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = AppDimensions.md;
        final tileWidth = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final tile in tiles)
              SizedBox(width: tileWidth, child: tile),
          ],
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final int value;
  final String label;

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
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(icon, color: color, size: AppDimensions.iconSize),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.patientFieldLabel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
