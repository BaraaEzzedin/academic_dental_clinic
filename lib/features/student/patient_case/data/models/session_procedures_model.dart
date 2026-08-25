import '../../domain/entities/session_procedures_entity.dart';
import 'session_procedure_model.dart';

class SessionProceduresModel extends SessionProceduresEntity {
  const SessionProceduresModel({
    required super.treatmentSessionId,
    required super.clinicalCaseId,
    required super.completed,
    required super.total,
    required super.percentage,
    required super.procedures,
  });

  factory SessionProceduresModel.fromJson(Map<String, dynamic> json) {
    final progress = json['progress'] as Map<String, dynamic>? ?? const {};
    final procedures = json['procedures'] as List<dynamic>? ?? const [];
    return SessionProceduresModel(
      treatmentSessionId: (json['treatmentSessionId'] as num?)?.toInt() ?? 0,
      clinicalCaseId: (json['clinicalCaseId'] as num?)?.toInt() ?? 0,
      completed: (progress['completed'] as num?)?.toInt() ?? 0,
      total: (progress['total'] as num?)?.toInt() ?? 0,
      percentage: (progress['percentage'] as num?)?.toInt() ?? 0,
      procedures: procedures
          .whereType<Map<String, dynamic>>()
          .map(SessionProcedureModel.fromJson)
          .toList(),
    );
  }
}
