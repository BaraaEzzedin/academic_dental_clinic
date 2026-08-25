import '../../domain/entities/available_procedure_entity.dart';

class AvailableProcedureModel extends AvailableProcedureEntity {
  const AvailableProcedureModel({
    required super.id,
    required super.name,
    super.requiredCount,
    super.description,
  });

  factory AvailableProcedureModel.fromJson(Map<String, dynamic> json) {
    return AvailableProcedureModel(
      id: (json['procedureId'] as num).toInt(),
      name: json['procedureName'] as String? ?? '',
      requiredCount: (json['requiredCount'] as num?)?.toInt(),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'procedureId': id,
      'procedureName': name,
      'requiredCount': requiredCount,
      'description': description,
    };
  }
}