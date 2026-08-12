import '../../domain/entities/case_acceptance_request_entity.dart';
import '../../domain/entities/procedure_request_entity.dart';
import '../../domain/entities/question_answer_entity.dart';
import '../../domain/entities/question_type.dart';

class CaseAcceptanceRequestModel extends CaseAcceptanceRequestEntity {
  const CaseAcceptanceRequestModel({
    required super.clinicalCaseId,
    required super.plannedProcedures,
  });

  factory CaseAcceptanceRequestModel.fromEntity(
    CaseAcceptanceRequestEntity entity,
  ) {
    return CaseAcceptanceRequestModel(
      clinicalCaseId: entity.clinicalCaseId,
      plannedProcedures: entity.plannedProcedures,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinicalCaseId': clinicalCaseId,
      'plannedProcedures': [
        for (final procedure in plannedProcedures) _procedureToJson(procedure),
      ],
    };
  }

  static Map<String, dynamic> _procedureToJson(ProcedureRequestEntity p) {
    return {
      'subjectProcedureId': p.procedureId,
      // `null` for subjects that do not require a dental chart.
      'toothNumber': p.toothNumber,
      'answers': [
        for (final answer in p.answers) _answerToJson(answer),
      ],
      // Notes are optional; omit the key entirely when empty.
      if (p.notes.trim().isNotEmpty) 'notes': p.notes.trim(),
    };
  }

  /// Serializes an answer to the shape the backend expects for its type:
  /// direct string `answer` for boolean/number, `optionIds` for choices.
  static Map<String, dynamic> _answerToJson(QuestionAnswerEntity answer) {
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

  static String _numberToString(num? value) {
    if (value == null) return '';
    if (value is int || value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }
}