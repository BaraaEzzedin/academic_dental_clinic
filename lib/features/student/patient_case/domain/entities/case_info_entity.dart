import 'package:equatable/equatable.dart';

/// Header/summary information from `caseInfo`. [rawStatus] is the backend
/// status string (e.g. `diagnosis_pending_review`) — mapped to a
/// [PatientStatus] in the presentation layer via `patientStatusFromApi`.
class CaseInfoEntity extends Equatable {
  const CaseInfoEntity({
    required this.patientId,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.subjectId,
    required this.subjectName,
    required this.requiresDentalChart,
    required this.supervisor,
    required this.nextSession,
    required this.rawStatus,
  });

  final int patientId;
  final String patientName;
  final int patientAge;
  final String patientGender;

  final int subjectId;
  final String subjectName;

  /// Drives the treatment-plan workflow: tooth-based when `true`,
  /// procedure-based when `false`. Sourced from `caseInfo.subject`.
  final bool requiresDentalChart;

  final String supervisor;
  final String nextSession;
  final String rawStatus;

  @override
  List<Object?> get props => [
        patientId,
        patientName,
        patientAge,
        patientGender,
        subjectId,
        subjectName,
        requiresDentalChart,
        supervisor,
        nextSession,
        rawStatus,
      ];
}
