import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/student_dashboard_entity.dart';
import 'circular_progress_ring.dart';
import 'dashboard_section.dart';

/// Section 6 — evaluation performance. Shows a highlighted average-grade card,
/// the evaluation count and a compact grade distribution. When there are no
/// evaluations yet, a friendly empty state replaces the details.
class EvaluationPerformanceCard extends StatelessWidget {
  const EvaluationPerformanceCard({super.key, required this.evaluations});

  final DashboardEvaluationsEntity evaluations;

  /// GPA scale used for the average-grade ring.
  static const double _maxPoints = 4.0;

  @override
  Widget build(BuildContext context) {
    if (!evaluations.hasEvaluations) {
      return DashboardCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardSectionTitle('Evaluation Performance'),
            const SizedBox(height: AppDimensions.lg),
            Row(
              children: [
                const Icon(
                  Icons.grade_outlined,
                  size: 22,
                  color: AppColors.textHint,
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Text(
                    'No evaluations available yet.',
                    style: AppTextStyles.subtitle,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    final points = evaluations.averagePoints ?? 0;
    final letter = (evaluations.averageLetter ?? '').trim();

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardSectionTitle(
            'Evaluation Performance',
            caption: '${evaluations.count} '
                '${evaluations.count == 1 ? 'Evaluation' : 'Evaluations'}',
          ),
          const SizedBox(height: AppDimensions.lg),
          _AverageGradeBanner(points: points, letter: letter, max: _maxPoints),
          const SizedBox(height: AppDimensions.lg),
          Text('Grade Distribution', style: AppTextStyles.fieldLabel),
          const SizedBox(height: AppDimensions.md),
          Wrap(
            spacing: AppDimensions.sm,
            runSpacing: AppDimensions.sm,
            children: [
              for (final entry in evaluations.gradeDistribution.entries)
                _GradeBadge(grade: entry.key, count: entry.value),
            ],
          ),
        ],
      ),
    );
  }
}

/// The highlighted average-grade block: a ring on the GPA scale beside the
/// letter grade and points. Uses the soft academic teal tint to stand out.
class _AverageGradeBanner extends StatelessWidget {
  const _AverageGradeBanner({
    required this.points,
    required this.letter,
    required this.max,
  });

  final double points;
  final String letter;
  final double max;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          CircularProgressRing(
            value: max == 0 ? 0 : points / max,
            size: 84,
            strokeWidth: 8,
            child: Text(
              letter.isEmpty ? '—' : letter,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AVERAGE GRADE', style: AppTextStyles.caseFieldLabel),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  '${_trim(points)} Points',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  'out of ${_trim(max)} GPA',
                  style: AppTextStyles.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _trim(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }
}

/// A compact academic badge: the letter grade with its count. Non-zero grades
/// are emphasized with the primary accent; zero grades stay muted.
class _GradeBadge extends StatelessWidget {
  const _GradeBadge({required this.grade, required this.count});

  final String grade;
  final int count;

  @override
  Widget build(BuildContext context) {
    final active = count > 0;
    final color = active ? AppColors.primary : AppColors.textHint;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: active
            ? AppColors.primary.withValues(alpha: 0.10)
            : AppColors.fieldFill,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(
          color: active
              ? AppColors.primary.withValues(alpha: 0.30)
              : AppColors.cardBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            grade,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(width: AppDimensions.xs),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: active ? AppColors.textPrimary : AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
