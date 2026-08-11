import '../../domain/entities/subject_config_entity.dart';
import 'available_procedure_model.dart';
import 'subject_question_model.dart';

class SubjectConfigModel extends SubjectConfigEntity {
  const SubjectConfigModel({
    required super.subjectId,
    required super.subjectName,
    required super.requiresDentalChart,
    required super.availableProcedures,
    required super.questions,
  });

  /// Parses the `data` object of the subject-configuration response.
  factory SubjectConfigModel.fromJson(Map<String, dynamic> json) {
    final procedures = json['procedures'] as List<dynamic>? ?? const [];
    final questions = json['questions'] as List<dynamic>? ?? const [];
    return SubjectConfigModel(
      subjectId: (json['subjectId'] as num).toInt(),
      subjectName: json['subjectName'] as String? ?? '',
      requiresDentalChart: json['requiresDentalChart'] as bool? ?? false,
      availableProcedures: procedures
          .map((e) =>
              AvailableProcedureModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      questions: questions
          .map((e) => SubjectQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}