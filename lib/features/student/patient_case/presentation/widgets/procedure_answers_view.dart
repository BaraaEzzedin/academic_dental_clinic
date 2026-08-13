import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/procedure_answer_entity.dart';

/// Renders a list of procedure [answers] as `question → value` rows.
///
/// Value is always human-readable ([ProcedureAnswerEntity.displayValue]):
/// boolean → Yes/No, number → the number, choice → option label(s). IDs are
/// never shown. Answers with no value are skipped. Renders nothing when there
/// is no answer to show, so callers can place it unconditionally.
class ProcedureAnswersView extends StatelessWidget {
  const ProcedureAnswersView({
    super.key,
    required this.answers,
    this.showHeader = true,
  });

  final List<ProcedureAnswerEntity> answers;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    final visible =
        answers.where((a) => a.displayValue != null).toList(growable: false);
    if (visible.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          Text('ANSWERS', style: AppTextStyles.caseFieldLabel),
          const SizedBox(height: AppDimensions.sm),
        ],
        for (var i = 0; i < visible.length; i++) ...[
          if (i > 0) const SizedBox(height: AppDimensions.sm),
          _AnswerRow(answer: visible[i]),
        ],
      ],
    );
  }
}

class _AnswerRow extends StatelessWidget {
  const _AnswerRow({required this.answer});

  final ProcedureAnswerEntity answer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          answer.question,
          style: AppTextStyles.caseToothLabel,
        ),
        const SizedBox(height: 2),
        Text(
          answer.displayValue ?? '—',
          style: AppTextStyles.caseProcedure,
        ),
      ],
    );
  }
}
