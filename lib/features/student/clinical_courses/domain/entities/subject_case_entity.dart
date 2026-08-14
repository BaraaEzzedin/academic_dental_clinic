import 'package:equatable/equatable.dart';

/// A patient case related to a subject, from
/// `GET /students/me/subjects/{id}` → `cases[]`. [rawStatus] is the backend
/// status string, mapped to a `PatientStatus` in the presentation layer.
class SubjectCaseEntity extends Equatable {
  const SubjectCaseEntity({
    required this.id,
    required this.patientName,
    required this.subjectName,
    required this.rawStatus,
    required this.sessionCount,
  });

  final int id;
  final String patientName;
  final String subjectName;
  final String rawStatus;
  final int sessionCount;

  @override
  List<Object?> get props =>
      [id, patientName, subjectName, rawStatus, sessionCount];
}