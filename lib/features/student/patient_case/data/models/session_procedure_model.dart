import '../../domain/entities/session_procedure_entity.dart';

class SessionProcedureModel extends SessionProcedureEntity {
  const SessionProcedureModel({
    required super.id,
    required super.name,
    required super.toothNumber,
    required super.rawStatus,
  });

  factory SessionProcedureModel.fromJson(Map<String, dynamic> json) {
    return SessionProcedureModel(
      id: (json['plannedProcedureId'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      toothNumber: (json['toothNumber'] as num?)?.toInt() ?? 0,
      rawStatus: json['status'] as String? ?? '',
    );
  }
}
