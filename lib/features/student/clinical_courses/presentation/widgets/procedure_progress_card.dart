import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/procedure_progress_entity.dart';
import '../utils/procedure_completion_ui.dart';
import 'subject_progress_bar.dart';

/// Compact card showing a single procedure's completion progress.
class ProcedureProgressCard extends StatelessWidget {
  const ProcedureProgressCard({super.key, required this.procedure});

  final ProcedureProgressEntity procedure;

  @override
  Widget build(BuildContext context) {
    final completion = procedure.completion;
    final accent = completion.color;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  procedure.procedure,
                  style: AppTextStyles.caseProcedure,
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              _CompletionBadge(completion: completion),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${procedure.completed} / ${procedure.requiredCount} '
                  'Completed',
                  style: AppTextStyles.timelinePhaseMeta,
                ),
              ),
              Text(
                '${procedure.percent}%',
                style: AppTextStyles.caseHighlightValue.copyWith(color: accent),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          SubjectProgressBar(value: procedure.fraction, color: accent),
        ],
      ),
    );
  }
}

class _CompletionBadge extends StatelessWidget {
  const _CompletionBadge({required this.completion});

  final ProcedureCompletion completion;

  @override
  Widget build(BuildContext context) {
    final color = completion.color;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Text(
        completion.label,
        style: AppTextStyles.statusBadge.copyWith(color: color),
      ),
    );
  }
}
