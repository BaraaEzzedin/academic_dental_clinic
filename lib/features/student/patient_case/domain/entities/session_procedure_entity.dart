import 'package:equatable/equatable.dart';

/// A single procedure for a treatment session, from
/// `GET /treatment-sessions/{id}/planned-procedures`. [rawStatus] is the raw
/// backend status (`planned` / `in_progress` / `completed`), mapped to a
/// presentation status in the presentation layer.
class SessionProcedureEntity extends Equatable {
  const SessionProcedureEntity({
    required this.id,
    required this.name,
    required this.toothNumber,
    required this.rawStatus,
  });

  final int id;
  final String name;
  final int toothNumber;
  final String rawStatus;

  @override
  List<Object?> get props => [id, name, toothNumber, rawStatus];
}
