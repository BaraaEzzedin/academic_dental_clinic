import '../../domain/entities/case_acceptance_request_entity.dart';
import 'procedure_request_json.dart';

class CaseAcceptanceRequestModel extends CaseAcceptanceRequestEntity {
  const CaseAcceptanceRequestModel({
    required super.clinicalCaseId,
    required super.plannedProcedures,
  });

  factory CaseAcceptanceRequestModel.fromEntity(
    CaseAcceptanceRequestEntity entity,
  ) {
    return CaseAcceptanceRequestModel(
      clinicalCaseId: entity.clinicalCaseId,
      plannedProcedures: entity.plannedProcedures,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinicalCaseId': clinicalCaseId,
      'plannedProcedures': [
        for (final procedure in plannedProcedures) procedureRequestToJson(procedure),
      ],
    };
  }
}