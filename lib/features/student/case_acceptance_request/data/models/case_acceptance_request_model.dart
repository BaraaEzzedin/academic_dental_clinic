import '../../domain/entities/case_acceptance_request_entity.dart';
import '../../domain/entities/question_answer_entity.dart';
import '../../domain/entities/question_type.dart';

class CaseAcceptanceRequestModel extends CaseAcceptanceRequestEntity {
  const CaseAcceptanceRequestModel({
    required super.patientId,
    required super.subjectId,
    required super.procedureRequests,
    super.media,
  });

  factory CaseAcceptanceRequestModel.fromEntity(
    CaseAcceptanceRequestEntity entity,
  ) {
    return CaseAcceptanceRequestModel(
      patientId: entity.patientId,
      subjectId: entity.subjectId,
      procedureRequests: entity.procedureRequests,
      media: entity.media,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'subjectId': subjectId,
      'media': media,
      'procedureRequests': [
        for (final request in procedureRequests)
          {
            // `null` for subjects that do not require a dental chart.
            'toothNumber': request.toothNumber,
            'procedureId': request.procedureId,
            'notes': request.notes,
            'answers': [
              for (final answer in request.answers) _answerToJson(answer),
            ],
          },
      ],
    };
  }

  /// Serializes an answer to the shape the backend expects for its type.
  static Map<String, dynamic> _answerToJson(QuestionAnswerEntity answer) {
    switch (answer.type) {
      case QuestionType.boolean:
        return {'questionId': answer.questionId, 'value': answer.boolValue};
      case QuestionType.number:
        return {'questionId': answer.questionId, 'value': answer.numberValue};
      case QuestionType.singleChoice:
      case QuestionType.multipleChoice:
        return {'questionId': answer.questionId, 'optionIds': answer.optionIds};
      case QuestionType.unknown:
        return {'questionId': answer.questionId};
    }
  }
}