import 'package:equatable/equatable.dart';
import 'procedure_request_entity.dart';

/// Payload submitted to the supervisor: the planned procedures for a case.
class CaseAcceptanceRequestEntity extends Equatable {
  const CaseAcceptanceRequestEntity({
    required this.clinicalCaseId,
    required this.plannedProcedures,
  });

  final int clinicalCaseId;
  final List<ProcedureRequestEntity> plannedProcedures;

  @override
  List<Object?> get props => [clinicalCaseId, plannedProcedures];
}