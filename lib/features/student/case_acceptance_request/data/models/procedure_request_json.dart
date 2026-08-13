import '../../domain/entities/procedure_request_entity.dart';
import '../../domain/entities/question_answer_entity.dart';
import '../../domain/entities/question_type.dart';

/// Serializes a planned procedure to the backend shape. Shared by the
/// case-acceptance submission and the walk-in (Add Patient) submission so the
/// `plannedProcedures` payload stays identical across both flows.
Map<String, dynamic> procedureRequestToJson(ProcedureRequestEntity p) {
  return {
    'subjectProcedureId': p.procedureId,
    // `null` for subjects that do not require a dental chart.
    'toothNumber': p.toothNumber,
    'answers': [
      for (final answer in p.answers) answerToJson(answer),
    ],
    // Notes are optional; omit the key entirely when empty.
    if (p.notes.trim().isNotEmpty) 'notes': p.notes.trim(),
  };
}

/// Serializes an answer to the shape the backend expects for its type:
/// direct string `answer` for boolean/number, `optionIds` for choices.
Map<String, dynamic> answerToJson(QuestionAnswerEntity answer) {
  switch (answer.type) {
    case QuestionType.boolean:
      return {
        'questionId': answer.questionId,
        'answer': (answer.boolValue ?? false).toString(),
      };
    case QuestionType.number:
      return {
        'questionId': answer.questionId,
        'answer': _numberToString(answer.numberValue),
      };
    case QuestionType.singleChoice:
    case QuestionType.multipleChoice:
      return {
        'questionId': answer.questionId,
        'optionIds': answer.optionIds,
      };
    case QuestionType.unknown:
      return {'questionId': answer.questionId};
  }
}

String _numberToString(num? value) {
  if (value == null) return '';
  if (value is int || value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toString();
}
