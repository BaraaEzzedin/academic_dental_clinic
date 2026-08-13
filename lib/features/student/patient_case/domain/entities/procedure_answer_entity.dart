import 'package:equatable/equatable.dart';
import 'selected_option_entity.dart';

/// A single answer to a procedure question. The backend sends either a raw
/// [rawAnswer] (boolean/number/text) or a list of [selectedOptions] for
/// single-/multiple-choice questions.
class ProcedureAnswerEntity extends Equatable {
  const ProcedureAnswerEntity({
    required this.question,
    this.rawAnswer,
    this.selectedOptions = const [],
  });

  final String question;

  /// Raw value for boolean/number/text answers; `null` for choice questions.
  final String? rawAnswer;

  /// Chosen options for single-/multiple-choice questions.
  final List<SelectedOptionEntity> selectedOptions;

  /// Human-readable value, resilient to every answer type. Never exposes IDs.
  ///
  /// - choice   -> joined option labels ("Heat", "Heat, Cold")
  /// - boolean  -> "Yes" / "No"
  /// - number   -> the number as-is ("6")
  /// - empty    -> `null` (callers hide the row or show a dash)
  String? get displayValue {
    if (selectedOptions.isNotEmpty) {
      return selectedOptions.map((o) => o.label).join(', ');
    }
    final value = rawAnswer?.trim();
    if (value == null || value.isEmpty) return null;
    return switch (value.toLowerCase()) {
      'true' => 'Yes',
      'false' => 'No',
      _ => value,
    };
  }

  @override
  List<Object?> get props => [question, rawAnswer, selectedOptions];
}
