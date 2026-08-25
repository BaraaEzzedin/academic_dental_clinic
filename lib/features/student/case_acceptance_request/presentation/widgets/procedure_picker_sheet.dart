import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/app_primary_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/sheet_grabber.dart';
import '../../domain/entities/available_procedure_entity.dart';
import '../../domain/entities/procedure_request_entity.dart';
import '../../domain/entities/question_answer_entity.dart';
import '../../domain/entities/question_type.dart';
import '../../domain/entities/subject_question_entity.dart';
import 'question_input.dart';

/// Called when the student saves the picked procedure. Matches the
/// `saveProcedureRequest` method on the case-acceptance / add-patient cubits so
/// it can be passed as a tear-off.
typedef SaveProcedureRequest = void Function({
  int? toothNumber,
  String? existingId,
  required AvailableProcedureEntity procedure,
  required List<QuestionAnswerEntity> answers,
  required String notes,
});

/// Cubit-agnostic procedure picker. The caller supplies the subject's
/// [procedures] / [questions] and an [onSave] callback, so this sheet is shared
/// by the case-acceptance flow and the Add Patient (walk-in) flow.
Future<void> showProcedurePickerSheet(
  BuildContext context, {
  required List<AvailableProcedureEntity> procedures,
  required List<SubjectQuestionEntity> questions,
  required SaveProcedureRequest onSave,
  int? toothNumber,
  ProcedureRequestEntity? existing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ProcedurePickerSheet(
      toothNumber: toothNumber,
      existing: existing,
      procedures: procedures,
      questions: questions,
      onSave: onSave,
    ),
  );
}

class _ProcedurePickerSheet extends StatefulWidget {
  const _ProcedurePickerSheet({
    required this.toothNumber,
    required this.existing,
    required this.procedures,
    required this.questions,
    required this.onSave,
  });

  final int? toothNumber;
  final ProcedureRequestEntity? existing;
  final List<AvailableProcedureEntity> procedures;
  final List<SubjectQuestionEntity> questions;
  final SaveProcedureRequest onSave;

  @override
  State<_ProcedurePickerSheet> createState() => _ProcedurePickerSheetState();
}

class _ProcedurePickerSheetState extends State<_ProcedurePickerSheet> {
  late int? _selectedProcedureId;
  late final Map<int, Object?> _answers;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _selectedProcedureId = existing?.procedureId;
    _answers = {
      for (final answer in existing?.answers ?? const [])
        answer.questionId: _rawValue(answer),
    };
    _notesController = TextEditingController(text: existing?.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  /// Restores the editable value for an already-saved answer.
  Object? _rawValue(QuestionAnswerEntity answer) {
    switch (answer.type) {
      case QuestionType.boolean:
        return answer.boolValue;
      case QuestionType.number:
        return answer.numberValue;
      case QuestionType.singleChoice:
        return answer.optionIds.isNotEmpty ? answer.optionIds.first : null;
      case QuestionType.multipleChoice:
        return List<int>.from(answer.optionIds);
      case QuestionType.unknown:
        return null;
    }
  }

  bool get _hasProcedure => _selectedProcedureId != null;

  bool get _requiredQuestionsAnswered =>
      widget.questions.where((q) => q.required).every(_isAnswered);

  bool get _canSave => _hasProcedure && _requiredQuestionsAnswered;

  /// Whether the current value for [question] counts as a valid answer.
  bool _isAnswered(SubjectQuestionEntity question) {
    final value = _answers[question.id];
    switch (question.type) {
      case QuestionType.boolean:
        return value is bool;
      case QuestionType.number:
        return value is num;
      case QuestionType.singleChoice:
        return value is int;
      case QuestionType.multipleChoice:
        return value is List<int> && value.isNotEmpty;
      case QuestionType.unknown:
        return true;
    }
  }

  /// Builds a typed answer, resolving option ids to readable texts.
  QuestionAnswerEntity? _buildAnswer(SubjectQuestionEntity question) {
    final value = _answers[question.id];
    switch (question.type) {
      case QuestionType.boolean:
        if (value is! bool) return null;
        return QuestionAnswerEntity(
          questionId: question.id,
          questionText: question.question,
          type: question.type,
          boolValue: value,
        );
      case QuestionType.number:
        if (value is! num) return null;
        return QuestionAnswerEntity(
          questionId: question.id,
          questionText: question.question,
          type: question.type,
          numberValue: value,
        );
      case QuestionType.singleChoice:
        if (value is! int) return null;
        return QuestionAnswerEntity(
          questionId: question.id,
          questionText: question.question,
          type: question.type,
          optionIds: [value],
          optionTexts: _optionTexts(question, {value}),
        );
      case QuestionType.multipleChoice:
        if (value is! List<int> || value.isEmpty) return null;
        final ids = value.toSet();
        final ordered = [
          for (final o in question.orderedOptions)
            if (ids.contains(o.id)) o.id,
        ];
        return QuestionAnswerEntity(
          questionId: question.id,
          questionText: question.question,
          type: question.type,
          optionIds: ordered,
          optionTexts: _optionTexts(question, ids),
        );
      case QuestionType.unknown:
        return null;
    }
  }

  List<String> _optionTexts(SubjectQuestionEntity question, Set<int> ids) => [
        for (final option in question.orderedOptions)
          if (ids.contains(option.id)) option.text,
      ];

  String get _title {
    if (widget.toothNumber != null) return 'Tooth #${widget.toothNumber}';
    return widget.existing != null ? 'Edit Procedure' : 'Add Procedure';
  }

  void _save() {
    final procedure = widget.procedures
        .firstWhere((p) => p.id == _selectedProcedureId);

    final answers = <QuestionAnswerEntity>[
      for (final question in widget.questions) ?_buildAnswer(question),
    ];

    widget.onSave(
      toothNumber: widget.toothNumber,
      existingId: widget.existing?.localId,
      procedure: procedure,
      answers: answers,
      notes: _notesController.text,
    );
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.94,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const Center(child: SheetGrabber()),
              _Header(title: _title),
              const Divider(height: 1, color: AppColors.dividerLine),
              Expanded(
                child: widget.procedures.isEmpty
                    ? const _EmptyProcedures()
                    : ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(
                          AppDimensions.xl,
                          AppDimensions.lg,
                          AppDimensions.xl,
                          AppDimensions.xl,
                        ),
                        children: [
                          Text('PROCEDURE',
                              style: AppTextStyles.caseFieldLabel),
                          const SizedBox(height: AppDimensions.md),
                          for (var i = 0;
                              i < widget.procedures.length;
                              i++) ...[
                            if (i > 0)
                              const SizedBox(height: AppDimensions.sm),
                            _ProcedureTile(
                              procedure: widget.procedures[i],
                              selected: widget.procedures[i].id ==
                                  _selectedProcedureId,
                              onTap: () => setState(
                                () => _selectedProcedureId =
                                    widget.procedures[i].id,
                              ),
                            ),
                          ],
                          if (widget.questions.isNotEmpty) ...[
                            const SizedBox(height: AppDimensions.xl),
                            Text('QUESTIONS',
                                style: AppTextStyles.caseFieldLabel),
                            const SizedBox(height: AppDimensions.md),
                            for (var i = 0;
                                i < widget.questions.length;
                                i++) ...[
                              if (i > 0)
                                const SizedBox(height: AppDimensions.lg),
                              QuestionInput(
                                question: widget.questions[i],
                                value: _answers[widget.questions[i].id],
                                onChanged: (value) => setState(
                                  () => _answers[widget.questions[i].id] =
                                      value,
                                ),
                              ),
                            ],
                          ],
                          const SizedBox(height: AppDimensions.xl),
                          AppTextField(
                            label: 'Additional Notes',
                            controller: _notesController,
                            hintText: 'Add any notes for this procedure…',
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            minLines: 3,
                            maxLines: 6,
                          ),
                        ],
                      ),
              ),
              _Footer(canSave: _canSave, onSave: _save),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.xl,
        AppDimensions.lg,
        AppDimensions.xl,
        AppDimensions.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.sectionTitle),
                const SizedBox(height: 2),
                Text('Select a procedure', style: AppTextStyles.helperText),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.close_rounded,
                color: AppColors.textSecondary),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.canSave, required this.onSave});

  final bool canSave;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.xl,
        AppDimensions.md,
        AppDimensions.xl,
        AppDimensions.lg + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.dividerLine)),
      ),
      child: AppPrimaryButton(
        label: 'Save Procedure',
        onPressed: canSave ? onSave : null,
        trailingIcon: Icons.check_rounded,
      ),
    );
  }
}

class _ProcedureTile extends StatelessWidget {
  const _ProcedureTile({
    required this.procedure,
    required this.selected,
    required this.onTap,
  });

  final AvailableProcedureEntity procedure;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primary.withValues(alpha: 0.08)
          : AppColors.fieldFill,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.fieldBorder,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      procedure.name,
                      style: AppTextStyles.caseProcedure.copyWith(
                        color: selected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    if (procedure.hasDescription) ...[
                      const SizedBox(height: 2),
                      Text(procedure.description!,
                          style: AppTextStyles.helperText),
                    ],
                    if (procedure.requiredCount != null) ...[
                      const SizedBox(height: AppDimensions.sm),
                      _RequiredCountBadge(count: procedure.requiredCount!),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color:
                    selected ? AppColors.primary : AppColors.indicatorInactive,
                size: AppDimensions.iconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequiredCountBadge extends StatelessWidget {
  const _RequiredCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Text(
        'Required: $count ${count == 1 ? 'case' : 'cases'}',
        style: AppTextStyles.scheduleMeta.copyWith(color: AppColors.primary),
      ),
    );
  }
}

class _EmptyProcedures extends StatelessWidget {
  const _EmptyProcedures();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.medical_services_outlined,
                size: 44, color: AppColors.indicatorInactive),
            const SizedBox(height: AppDimensions.md),
            Text(
              'No procedures available for this subject.',
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
          ],
        ),
      ),
    );
  }
}