import 'package:equatable/equatable.dart';

/// Full detail payload for a single assigned patient, shown on the Assigned
/// Patient Details screen. It aggregates everything the student needs to review
/// before submitting a case-acceptance request to the supervisor.
///
/// TODO(backend): map this from the real API response once the assigned-patient
/// details endpoint is ready. The identifying fields ([patientName],
/// [subjectName], [chiefComplaint], [appointmentDate]) come straight from the
/// list entity so nothing drifts between the list and this screen.
class AssignedPatientDetailsEntity extends Equatable {
  const AssignedPatientDetailsEntity({
    required this.id,
    required this.patientName,
    required this.subjectId,
    required this.subjectName,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.clinic,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.chiefComplaint,
    required this.symptoms,
    required this.currentMedications,
    required this.medicalConditions,
    required this.allergies,
  });

  final int id;
  final String patientName;

  /// Identifier of the subject this case is filed under — used to fetch the
  /// available procedures on the Case Acceptance Request screen.
  final int subjectId;
  final String subjectName;
  final int age;
  final String gender;
  final String phoneNumber;
  final String clinic;

  /// Initial examination appointment.
  final DateTime appointmentDate;
  final String appointmentTime;

  /// The main complaint — identical to the one shown on the assigned-patient
  /// list card.
  final String chiefComplaint;

  final List<String> symptoms;
  final List<String> currentMedications;
  final List<String> medicalConditions;
  final List<String> allergies;

  @override
  List<Object?> get props => [
        id,
        patientName,
        subjectId,
        subjectName,
        age,
        gender,
        phoneNumber,
        clinic,
        appointmentDate,
        appointmentTime,
        chiefComplaint,
        symptoms,
        currentMedications,
        medicalConditions,
        allergies,
      ];
}