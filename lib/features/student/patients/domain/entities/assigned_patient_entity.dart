import 'package:equatable/equatable.dart';

import '../../../../../core/enums/patient_status.dart';


class AssignedPatientEntity extends Equatable {
  const AssignedPatientEntity({
    required this.id,
    required this.patientName,
    required this.subject,
    required this.procedure,
    required this.sessionNumber,
    required this.status,
  });

  final int id;
  final String patientName;
  final String subject;
  final String procedure;
  final int sessionNumber;
  final PatientStatus status;

  @override
  List<Object?> get props => [
        id,
        patientName,
        subject,
        procedure,
        sessionNumber,
        status,
      ];
}