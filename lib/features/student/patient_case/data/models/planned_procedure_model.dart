import '../../domain/entities/planned_procedure_entity.dart';
import 'procedure_answer_model.dart';

class PlannedProcedureModel extends PlannedProcedureEntity {
  const PlannedProcedureModel({
    required super.procedure,
    super.tooth,
    super.rawStatus,
    super.notes,
    super.answers,
  });

  factory PlannedProcedureModel.fromJson(Map<String, dynamic> json) {
    final answers = json['answers'] as List<dynamic>? ?? const [];
    return PlannedProcedureModel(
      procedure: json['procedure'] as String? ?? '',
      tooth: (json['tooth'] as num?)?.toInt(),
      rawStatus: json['status'] as String?,
      notes: json['notes'] as String?,
      answers: answers
          .whereType<Map<String, dynamic>>()
          .map(ProcedureAnswerModel.fromJson)
          .toList(),
    );
  }
}
