import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../clinical_courses/presentation/widgets/subject_progress_bar.dart';
import '../../domain/entities/student_dashboard_entity.dart';
import 'dashboard_section.dart';

/// Section 7 — subjects ranked by completion so the strongest and weakest are
/// obvious at a glance, without comparing the full subject cards.
class SubjectRankingCard extends StatelessWidget {
  const SubjectRankingCard({super.key, required this.subjects});

  final List<DashboardSubjectEntity> subjects;

  @override
  Widget build(BuildContext context) {
    final ranked = [...subjects]
      ..sort((a, b) => b.completionPercentage.compareTo(a.completionPercentage));

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardSectionTitle(
            'Most Progressed Subjects',
            caption: 'Where you are strongest and where to focus next',
          ),
          const SizedBox(height: AppDimensions.lg),
          for (var i = 0; i < ranked.length; i++) ...[
            if (i > 0) const SizedBox(height: AppDimensions.md),
            _RankRow(rank: i + 1, subject: ranked[i]),
          ],
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({required this.rank, required this.subject});

  final int rank;
  final DashboardSubjectEntity subject;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Text(
            '$rank',
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      subject.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.timelinePhaseTitle,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Text(
                    '${_trim(subject.completionPercentage)}%',
                    style: AppTextStyles.caseHighlightValue,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.sm),
              SubjectProgressBar(
                value: subject.completionPercentage / 100,
                height: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _trim(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }
}
