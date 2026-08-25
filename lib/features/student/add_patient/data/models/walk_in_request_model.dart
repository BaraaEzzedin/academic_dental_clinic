import '../../../case_acceptance_request/data/models/procedure_request_json.dart';
import '../../domain/entities/walk_in_request_entity.dart';

/// Builds the JSON object sent as the multipart `data` field. Its
/// `plannedProcedures` uses the shared [procedureRequestToJson] so the shape
/// matches the case-acceptance submission exactly. Case images are NOT part of
/// this object — they travel as the separate multipart `images` file parts.
class WalkInRequestModel {
  const WalkInRequestModel(this.entity);

  final WalkInRequestEntity entity;

  Map<String, dynamic> toDataJson() {
    final info = entity.patientInfo;
    return {
      'patient': {
        'patientInfo': {
          'full_name': info.fullName.trim(),
          'phone': info.phone.trim(),
          'dateOfBirth': info.dateOfBirth,
          'gender': info.gender,
          'allergies': info.allergies.trim(),
          'medical_history': info.medicalHistory.trim(),
          'current_medications': info.currentMedications.trim(),
        },
        'symptoms': info.symptoms.trim(),
        'chiefComplaint': info.chiefComplaint.trim(),
      },
      'caseInfo': {
        'subjectId': entity.subjectId,
        'plannedProcedures': [
          for (final procedure in entity.plannedProcedures)
            procedureRequestToJson(procedure),
        ],
      },
      'appointment': {
        'appointmentDate': entity.appointmentDate,
        'appointmentStart': entity.appointmentStart,
      },
    };
  }
}
