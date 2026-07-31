import '../../domain/entities/assigned_patient_entity.dart';
import '../mapper/patient_status_mapper.dart';

class AssignedPatientModel extends AssignedPatientEntity {
  const AssignedPatientModel({
    required super.id,
    required super.patientName,
    required super.subject,
    required super.sessionNumber,
    required super.status,
  });

  factory AssignedPatientModel.fromJson(Map<String, dynamic> json) {
    return AssignedPatientModel(
      id: (json['id'] as num).toInt(),
      patientName: json['patientName'] as String,
      subject: json['subjectName'] as String,
      sessionNumber: (json['sessionCount'] as num).toInt(),
      status: patientStatusFromApi(json['status'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'subjectName': subject,
      'sessionCount': sessionNumber,
      'status': patientStatusToApi(status),
    };
  }
}