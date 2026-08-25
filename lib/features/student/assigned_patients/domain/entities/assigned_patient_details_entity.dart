import 'package:equatable/equatable.dart';

class AssignedPatientDetailsEntity extends Equatable {
  const AssignedPatientDetailsEntity({
    required this.id,
    required this.status,
    required this.patientId,
    required this.patientName,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    required this.clinic,
    required this.medicalHistory,
    required this.currentMedications,
    required this.allergies,
    required this.subjectId,
    required this.subjectName,
    required this.chiefComplaint,
    required this.symptoms,
    required this.assignedStudentName,
    required this.assignedSupervisorName,
    required this.appointmentDate,
    required this.appointmentStartTime,
    required this.appointmentEndTime,
  });


  final int id;
  final String status;

  final int patientId;
  final String patientName;
  final DateTime? dateOfBirth;
  final String gender;
  final String phoneNumber;
  final String clinic;

  final String medicalHistory;
  final String currentMedications;
  final String allergies;

  final int subjectId;
  final String subjectName;

  final String chiefComplaint;

  final String symptoms;

  final String assignedStudentName;
  final String assignedSupervisorName;

  final DateTime appointmentDate;
  final String appointmentStartTime;
  final String appointmentEndTime;

  @override
  List<Object?> get props => [
        id,
        status,
        patientId,
        patientName,
        dateOfBirth,
        gender,
        phoneNumber,
        clinic,
        medicalHistory,
        currentMedications,
        allergies,
        subjectId,
        subjectName,
        chiefComplaint,
        symptoms,
        assignedStudentName,
        assignedSupervisorName,
        appointmentDate,
        appointmentStartTime,
        appointmentEndTime,
      ];
}