import 'package:equatable/equatable.dart';


class AssignedPatientEntity extends Equatable {
  const AssignedPatientEntity({
    required this.id,
    required this.patientName,
    required this.subjectName,
    required this.chiefComplaint,
    this.appointmentDate,
  });

  final int id;
  final String patientName;
  final String subjectName;
  final String chiefComplaint;

  /// Date of the next appointment, or `null` when none is scheduled yet.
  final DateTime? appointmentDate;

  @override
  List<Object?> get props => [
        id,
        patientName,
        subjectName,
        chiefComplaint,
        appointmentDate,
      ];
}