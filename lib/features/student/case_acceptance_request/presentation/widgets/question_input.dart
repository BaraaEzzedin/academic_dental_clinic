import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/answer_option_entity.dart';
import '../../domain/entities/question_type.dart';
import '../../domain/entities/subject_question_entity.dart';

class QuestionInput extends StatelessWidget {
  const QuestionInput({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final SubjectQuestionEntity question;

  final Object? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(question.question, style: AppTextStyles.fieldLabel),
            ),
            if (question.required)
              Text(
                ' *',
                style:
                    AppTextStyles.fieldLabel.copyWith(color: AppColors.error),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        _buildInput(),
      ],
    );
  }

  Widget _buildInput() {
    switch (question.type) {
      case QuestionType.boolean:
        return _BooleanInput(
          value: value is bool ? value! as bool : null,
          onChanged: onChanged,
        );
      case QuestionType.number:
        return _NumberInput(
          value: value is num ? value! as num : null,
          onChanged: onChanged,
        );
      case QuestionType.singleChoice:
        return _SingleChoiceInput(
          options: question.orderedOptions,
          value: value is int ? value! as int : null,
          onChanged: onChanged,
        );
      case QuestionType.multipleChoice:
        return _MultipleChoiceInput(
          options: question.orderedOptions,
          value: value is List<int> ? value! as List<int> : const [],
          onChanged: onChanged,
        );
      case QuestionType.unknown:
        return const _UnsupportedInput();
    }
  }
}

class _BooleanInput extends StatelessWidget {
  const _BooleanInput({required this.value, required this.onChanged});

  final bool? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ChoicePill(
            label: 'Yes',
            selected: value == true,
            multiSelect: false,
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _ChoicePill(
            label: 'No',
            selected: value == false,
            multiSelect: false,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _NumberInput extends StatefulWidget {
  const _NumberInput({required this.value, required this.onChanged});

  final num? value;
  final ValueChanged<Object?> onChanged;

  @override
  State<_NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<_NumberInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value != null ? _format(widget.value!) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _format(num value) =>
      value == value.roundToDouble() ? value.toInt().toString() : '$value';

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: AppTextStyles.input,
      cursorColor: AppColors.primary,
      onChanged: (raw) =>
          widget.onChanged(raw.isEmpty ? null : int.tryParse(raw)),
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Enter a number',
        hintStyle: AppTextStyles.hint,
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.lg,
          vertical: AppDimensions.lg,
        ),
        border: _border(AppColors.fieldBorder),
        enabledBorder: _border(AppColors.fieldBorder),
        focusedBorder: _border(AppColors.primary),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(color: color),
      );
}

class _SingleChoiceInput extends StatelessWidget {
  const _SingleChoiceInput({
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<AnswerOptionEntity> options;
  final int? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(height: AppDimensions.sm),
          _ChoicePill(
            label: options[i].text,
            selected: value == options[i].id,
            multiSelect: false,
            onTap: () => onChanged(options[i].id),
          ),
        ],
      ],
    );
  }
}

class _MultipleChoiceInput extends StatelessWidget {
  const _MultipleChoiceInput({
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<AnswerOptionEntity> options;
  final List<int> value;
  final ValueChanged<Object?> onChanged;

  void _toggle(int optionId) {
    final updated = [...value];
    if (updated.contains(optionId)) {
      updated.remove(optionId);
    } else {
      updated.add(optionId);
    }
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(height: AppDimensions.sm),
          _ChoicePill(
            label: options[i].text,
            selected: value.contains(options[i].id),
            multiSelect: true,
            onTap: () => _toggle(options[i].id),
          ),
        ],
      ],
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.multiSelect,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool multiSelect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final IconData icon = multiSelect
        ? (selected
            ? Icons.check_box_rounded
            : Icons.check_box_outline_blank_rounded)
        : (selected
            ? Icons.check_circle_rounded
            : Icons.radio_button_unchecked_rounded);
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
            horizontal: AppDimensions.md,
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
              Icon(
                icon,
                size: 18,
                color:
                    selected ? AppColors.primary : AppColors.indicatorInactive,
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caseProcedure.copyWith(
                    color:
                        selected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnsupportedInput extends StatelessWidget {
  const _UnsupportedInput();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Text(
        'This question type is not supported yet.',
        style: AppTextStyles.helperText,
      ),
    );
  }
}