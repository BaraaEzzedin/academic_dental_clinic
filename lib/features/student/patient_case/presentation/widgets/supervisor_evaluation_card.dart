import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../domain/entities/supervisor_evaluation_entity.dart';

/// The case's final supervisor evaluation, presented as the closing outcome of
/// the Case Details screen.
///
/// Rendered only when an evaluation exists; the caller is responsible for
/// hiding the whole section when [evaluation] is `null`. The card intentionally
/// stands apart from the regular white information cards with a soft academic
/// teal wash, an accented border and a subtle lift — a positive "result of the
/// case" feel, using the app's own primary accent (no error/warning colors).
class SupervisorEvaluationCard extends StatelessWidget {
  const SupervisorEvaluationCard({
    super.key,
    required this.evaluation,
    this.supervisorName,
  });

  final SupervisorEvaluationEntity evaluation;

  /// The evaluating supervisor, shown as "Evaluated by". Sourced from the case
  /// info since the evaluation payload carries only the grade and comment.
  final String? supervisorName;

  @override
  Widget build(BuildContext context) {
    final grade = evaluation.grade.trim();
    final comment = evaluation.comment.trim();
    final supervisor = supervisorName?.trim() ?? '';
    final date = evaluation.createdAt != null
        ? DateFormatter.toMediumDate(evaluation.createdAt!)
        : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.primary,
                  size: AppDimensions.iconSize,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FINAL ASSESSMENT', style: AppTextStyles.caseFieldLabel),
                    const SizedBox(height: 2),
                    Text('Supervisor Evaluation',
                        style: AppTextStyles.sectionTitle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.lg),
          const Divider(height: 1, color: AppColors.dividerLine),
          const SizedBox(height: AppDimensions.lg),
          if (grade.isNotEmpty) _GradeHighlight(grade: grade),
          if (comment.isNotEmpty) ...[
            if (grade.isNotEmpty) const SizedBox(height: AppDimensions.lg),
            Text(comment, style: AppTextStyles.noteMessage),
          ],
          if (supervisor.isNotEmpty || date.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.lg),
            _EvaluatedBy(supervisor: supervisor, date: date),
          ],
        ],
      ),
    );
  }
}

/// The awarded grade, the most prominent element of the section.
class _GradeHighlight extends StatelessWidget {
  const _GradeHighlight({required this.grade});

  final String grade;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(minWidth: 96),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.xl,
          vertical: AppDimensions.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('GRADE', style: AppTextStyles.caseFieldLabel),
            const SizedBox(height: AppDimensions.xs),
            Text(
              grade,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                height: 1.0,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Attribution line: which supervisor evaluated the case and when.
class _EvaluatedBy extends StatelessWidget {
  const _EvaluatedBy({required this.supervisor, required this.date});

  final String supervisor;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.logoBorder,
          child: Icon(
            Icons.person_rounded,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (supervisor.isNotEmpty) ...[
                Text('EVALUATED BY', style: AppTextStyles.caseFieldLabel),
                const SizedBox(height: 2),
                Text(
                  supervisor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caseFieldValue,
                ),
              ],
              if (date.isNotEmpty) ...[
                if (supervisor.isNotEmpty)
                  const SizedBox(height: AppDimensions.xs),
                Text(date, style: AppTextStyles.noteMeta),
              ],
            ],
          ),
        ),
      ],
    );
  }
}