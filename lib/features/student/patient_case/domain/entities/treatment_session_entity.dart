import 'package:equatable/equatable.dart';

/// A single treatment session returned by
/// `GET /treatment-sessions/student?clinicalCaseId={id}`. [rawStatus] is the
/// backend status string (e.g. `completed`, `in_progress`) — mapped to a
/// presentation `SessionStatus` in the presentation layer.
class TreatmentSessionEntity extends Equatable {
  const TreatmentSessionEntity({
    required this.id,
    required this.title,
    required this.rawStatus,
    required this.notes,
    required this.appointmentDate,
    required this.startTime,
  });

  final int id;
  final String title;
  final String rawStatus;
  final String notes;
  final DateTime? appointmentDate;
  final String startTime;

  @override
  List<Object?> get props =>
      [id, title, rawStatus, notes, appointmentDate, startTime];
}