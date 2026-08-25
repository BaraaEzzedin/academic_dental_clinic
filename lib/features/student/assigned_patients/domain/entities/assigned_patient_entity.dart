import 'package:equatable/equatable.dart';


class AssignedPatientEntity extends Equatable {
  const AssignedPatientEntity({
    required this.id,
    required this.patientName,
    required this.subjectName,
    required this.chiefComplaint,
    required this.appointmentDate,
  });

  final int id;
  final String patientName;
  final String subjectName;
  final String chiefComplaint;
  final DateTime appointmentDate;

  @override
  List<Object?> get props => [
        id,
        patientName,
        subjectName,
        chiefComplaint,
        appointmentDate,
      ];
}