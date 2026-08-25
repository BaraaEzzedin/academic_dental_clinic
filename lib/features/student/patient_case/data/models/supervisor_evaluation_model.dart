import '../../domain/entities/supervisor_evaluation_entity.dart';

class SupervisorEvaluationModel extends SupervisorEvaluationEntity {
  const SupervisorEvaluationModel({
    required super.grade,
    required super.comment,
    super.createdAt,
  });

  factory SupervisorEvaluationModel.fromJson(Map<String, dynamic> json) {
    return SupervisorEvaluationModel(
      grade: json['grade'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
    );
  }
}