import 'package:equatable/equatable.dart';

import 'session_procedure_entity.dart';

/// The planned-procedures payload for a treatment session, including the
/// progress summary and the list of procedures.
class SessionProceduresEntity extends Equatable {
  const SessionProceduresEntity({
    required this.treatmentSessionId,
    required this.clinicalCaseId,
    required this.completed,
    required this.total,
    required this.percentage,
    required this.procedures,
  });

  final int treatmentSessionId;
  final int clinicalCaseId;
  final int completed;
  final int total;
  final int percentage;
  final List<SessionProcedureEntity> procedures;

  @override
  List<Object?> get props => [
        treatmentSessionId,
        clinicalCaseId,
        completed,
        total,
        percentage,
        procedures,
      ];
}
