import '../../domain/entities/available_procedure_entity.dart';

class AvailableProcedureModel extends AvailableProcedureEntity {
  const AvailableProcedureModel({
    required super.id,
    required super.name,
    super.description,
  });

  factory AvailableProcedureModel.fromJson(Map<String, dynamic> json) {
    return AvailableProcedureModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] ?? json['procedureName']) as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}