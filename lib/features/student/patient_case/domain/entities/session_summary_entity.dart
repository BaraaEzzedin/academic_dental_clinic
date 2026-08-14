import 'package:equatable/equatable.dart';

/// One treatment item in a completed session's summary.
class SummaryTreatmentItemEntity extends Equatable {
  const SummaryTreatmentItemEntity({
    required this.procedureName,
    required this.toothNumber,
    required this.rawStatus,
  });

  final String procedureName;
  final int toothNumber;
  final String rawStatus;

  @override
  List<Object?> get props => [procedureName, toothNumber, rawStatus];
}

/// Summary of a completed treatment session, from
/// `GET /treatment-sessions/summary/{sessionId}`.
class SessionSummaryEntity extends Equatable {
  const SessionSummaryEntity({
    required this.id,
    required this.title,
    required this.appointmentDate,
    required this.treatmentItems,
    required this.notes,
  });

  final int id;
  final String title;
  final DateTime? appointmentDate;
  final List<SummaryTreatmentItemEntity> treatmentItems;
  final String notes;

  @override
  List<Object?> get props =>
      [id, title, appointmentDate, treatmentItems, notes];
}
