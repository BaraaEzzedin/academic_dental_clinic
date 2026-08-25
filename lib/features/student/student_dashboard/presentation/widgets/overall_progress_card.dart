import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/student_dashboard_entity.dart';
import 'circular_progress_ring.dart';
import 'dashboard_section.dart';

/// Section 2 — the headline metric: overall completion as a large ring, with
/// the procedures completed / required beside it.
class OverallProgressCard extends StatelessWidget {
  const OverallProgressCard({super.key, required this.stats});

  final DashboardStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final percent = stats.overallCompletionPercentage;
    return DashboardCard(
      padding: const EdgeInsets.all(AppDimensions.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardSectionTitle(
            'Overall Progress',
            caption: 'Your total clinical completion so far',
          ),
          const SizedBox(height: AppDimensions.xl),
          Row(
            children: [
              CircularProgressRing(
                value: percent / 100,
                size: 140,
                strokeWidth: 13,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_trim(percent)}%',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text('COMPLETE', style: AppTextStyles.caseFieldLabel),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.0,
                        ),
                        children: [
                          TextSpan(text: '${stats.completedProcedures}'),
                          TextSpan(
                            text: ' / ${stats.requiredProcedures}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      'Procedures completed',
                      style: AppTextStyles.subtitle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// "27.3" without a trailing ".0".
  static String _trim(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }
}
