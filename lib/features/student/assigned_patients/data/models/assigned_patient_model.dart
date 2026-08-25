import '../../domain/entities/assigned_patient_entity.dart';

class AssignedPatientModel extends AssignedPatientEntity {
  const AssignedPatientModel({
    required super.id,
    required super.patientName,
    required super.subjectName,
    required super.chiefComplaint,
    required super.appointmentDate,
  });

  factory AssignedPatientModel.fromJson(Map<String, dynamic> json) {
    final nextAppointment = json['nextAppointment'] as Map<String, dynamic>;
    return AssignedPatientModel(
      id: (json['id'] as num).toInt(),
      patientName: json['patient'] as String? ?? '',
      subjectName:
          (json['subject'] as Map<String, dynamic>?)?['name'] as String? ?? '',
      chiefComplaint: json['chiefComplaint'] as String? ?? '',
      appointmentDate:
          DateTime.parse(nextAppointment['appointmentDate'] as String),
    );
  }
}