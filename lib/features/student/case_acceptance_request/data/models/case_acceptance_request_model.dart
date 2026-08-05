import '../../domain/entities/case_acceptance_request_entity.dart';

class CaseAcceptanceRequestModel extends CaseAcceptanceRequestEntity {
  const CaseAcceptanceRequestModel({
    required super.patientId,
    required super.subjectId,
    required super.selections,
    required super.diagnosis,
  });

  factory CaseAcceptanceRequestModel.fromEntity(
    CaseAcceptanceRequestEntity entity,
  ) {
    return CaseAcceptanceRequestModel(
      patientId: entity.patientId,
      subjectId: entity.subjectId,
      selections: entity.selections,
      diagnosis: entity.diagnosis,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'subjectId': subjectId,
      'diagnosis': diagnosis,
      'teeth': [
        for (final tooth in selections)
          {
            'toothNumber': tooth.toothNumber,
            'procedureId': tooth.procedureId,
          },
      ],
    };
  }
}