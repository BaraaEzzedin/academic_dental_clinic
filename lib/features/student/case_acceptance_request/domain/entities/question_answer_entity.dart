import 'package:equatable/equatable.dart';
import 'question_type.dart';

/// A single answered question attached to a procedure request.
///
/// The value is stored in the field matching [type] so the data layer can build
/// the correct submission payload:
/// * [QuestionType.boolean]        → `{ questionId, value: bool }`
/// * [QuestionType.number]         → `{ questionId, value: num }`
/// * [QuestionType.singleChoice]   → `{ questionId, optionIds: [id] }`
/// * [QuestionType.multipleChoice] → `{ questionId, optionIds: [ids…] }`
class QuestionAnswerEntity extends Equatable {
  const QuestionAnswerEntity({
    required this.questionId,
    required this.questionText,
    required this.type,
    this.boolValue,
    this.numberValue,
    this.optionIds = const [],
    this.optionTexts = const [],
  });

  final int questionId;
  final String questionText;
  final QuestionType type;

  final bool? boolValue;
  final num? numberValue;

  /// Selected option ids for choice questions.
  final List<int> optionIds;

  /// Selected option texts, resolved at save time for readable summaries.
  final List<String> optionTexts;

  /// Human-readable answer used in the summary cards (never raw ids).
  String get displayAnswer {
    switch (type) {
      case QuestionType.boolean:
        return boolValue == true ? 'Yes' : 'No';
      case QuestionType.number:
        return numberValue != null ? _formatNumber(numberValue!) : '—';
      case QuestionType.singleChoice:
      case QuestionType.multipleChoice:
        return optionTexts.isNotEmpty ? optionTexts.join(', ') : '—';
      case QuestionType.unknown:
        return '—';
    }
  }

  static String _formatNumber(num value) {
    if (value is int || value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  @override
  List<Object?> get props => [
        questionId,
        questionText,
        type,
        boolValue,
        numberValue,
        optionIds,
        optionTexts,
      ];
}