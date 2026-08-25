import '../../domain/entities/assigned_patient_details_entity.dart';

class AssignedPatientDetailsModel extends AssignedPatientDetailsEntity {
  const AssignedPatientDetailsModel({
    required super.id,
    required super.status,
    required super.patientId,
    required super.patientName,
    required super.dateOfBirth,
    required super.gender,
    required super.phoneNumber,
    required super.clinic,
    required super.medicalHistory,
    required super.currentMedications,
    required super.allergies,
    required super.subjectId,
    required super.subjectName,
    required super.chiefComplaint,
    required super.symptoms,
    required super.assignedStudentName,
    required super.assignedSupervisorName,
    required super.appointmentDate,
    required super.appointmentStartTime,
    required super.appointmentEndTime,
  });

  factory AssignedPatientDetailsModel.fromJson(Map<String, dynamic> json) {
    final patient = json['patient'] as Map<String, dynamic>? ?? const {};
    final request = json['patientRequest'] as Map<String, dynamic>? ?? const {};
    final subject = json['subject'] as Map<String, dynamic>? ?? const {};
    final student = json['assignedStudent'] as Map<String, dynamic>?;
    final supervisor = json['assignedSupervisor'] as Map<String, dynamic>?;
    final section = supervisor?['section'] as Map<String, dynamic>?;
    final appointment = json['nextAppointment'] as Map<String, dynamic>?;

    return AssignedPatientDetailsModel(
      id: (json['id'] as num).toInt(),
      status: json['status'] as String? ?? '',
      patientId: (patient['id'] as num?)?.toInt() ?? 0,
      patientName: patient['fullName'] as String? ?? '',
      // The supervisor's section stands in for the clinic the case is seen at.
      dateOfBirth: DateTime.tryParse(patient['dateOfBirth'] as String? ?? ''),
      gender: patient['gender'] as String? ?? '',
      phoneNumber: patient['phone'] as String? ?? '',
      clinic: section?['name'] as String? ?? '',
      medicalHistory: patient['medicalHistory'] as String? ?? '',
      currentMedications: patient['currentMedications'] as String? ?? '',
      allergies: patient['allergies'] as String? ?? '',
      subjectId: (subject['id'] as num?)?.toInt() ?? 0,
      subjectName: subject['name'] as String? ?? '',
      chiefComplaint: request['chiefComplaint'] as String? ?? '',
      symptoms: request['symptoms'] as String? ?? '',
      assignedStudentName: student?['name'] as String? ?? '',
      assignedSupervisorName: supervisor?['name'] as String? ?? '',
      appointmentDate:
          DateTime.parse(appointment!['appointmentDate'] as String),
      appointmentStartTime: appointment['startTime'] as String? ?? '',
      appointmentEndTime: appointment['endTime'] as String? ?? '',
    );
  }
}