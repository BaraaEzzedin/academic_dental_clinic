import '../../domain/entities/question_type.dart';
import '../../domain/entities/subject_question_entity.dart';
import 'answer_option_model.dart';

class SubjectQuestionModel extends SubjectQuestionEntity {
  const SubjectQuestionModel({
    required super.id,
    required super.question,
    required super.type,
    required super.required,
    required super.displayOrder,
    super.options,
  });

  factory SubjectQuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['answerOptions'] as List<dynamic>? ?? const [];
    return SubjectQuestionModel(
      id: (json['questionId'] as num).toInt(),
      question: json['questionText'] as String? ?? '',
      type: QuestionType.fromApi(json['questionType'] as String?),
      required: json['required'] as bool? ?? false,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      options: rawOptions
          .map((e) => AnswerOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}