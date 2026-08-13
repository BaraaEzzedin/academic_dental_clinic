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
    required this.nextSessionDate,
    required this.nextSessionTime,
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

  /// Next session's date (e.g. "Aug 16, 2026") and time (e.g. "11:00 AM"),
  /// shown stacked in the case header. Empty when no session is booked.
  final String nextSessionDate;
  final String nextSessionTime;

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
        nextSessionDate,
        nextSessionTime,
        rawStatus,
      ];
}
