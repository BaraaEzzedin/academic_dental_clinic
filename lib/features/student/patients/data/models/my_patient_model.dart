import '../../domain/entities/assigned_patient_entity.dart';
import '../mapper/patient_status_mapper.dart';

class MyPatientModel extends MyPatientEntity {
  const MyPatientModel({
    required super.id,
    required super.patientName,
    required super.subject,
    required super.sessionNumber,
    required super.status,
  });

  factory MyPatientModel.fromJson(Map<String, dynamic> json) {
    return MyPatientModel(
      id: (json['id'] as num).toInt(),
      patientName: json['patientName'] as String,
      subject: (json['subject'] as Map<String, dynamic>?)?['name'] as String? ?? '',
      sessionNumber: switch (json['sessionCount']) {
        final num n => n.toInt(),
        _ => null,
      },
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