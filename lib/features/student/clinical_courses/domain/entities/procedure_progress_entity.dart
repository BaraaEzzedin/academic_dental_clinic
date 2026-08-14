import 'package:equatable/equatable.dart';

/// Completion state of a single procedure, derived from completed vs required.
enum ProcedureCompletion { notStarted, inProgress, completed }

/// Progress of one procedure within a subject, from
/// `GET /students/me/subjects/{id}` → `procedures[]`.
class ProcedureProgressEntity extends Equatable {
  const ProcedureProgressEntity({
    required this.subjectProcedureId,
    required this.procedure,
    required this.completed,
    required this.requiredCount,
  });

  final int subjectProcedureId;
  final String procedure;
  final int completed;

  /// Number of procedures required (the JSON `required` field).
  final int requiredCount;

  /// completed / required, clamped to 0..1. 0 when nothing is required.
  double get fraction {
    if (requiredCount <= 0) return 0;
    return (completed / requiredCount).clamp(0.0, 1.0);
  }

  int get percent => (fraction * 100).round();

  ProcedureCompletion get completion {
    if (completed <= 0) return ProcedureCompletion.notStarted;
    if (completed < requiredCount) return ProcedureCompletion.inProgress;
    return ProcedureCompletion.completed;
  }

  @override
  List<Object?> get props =>
      [subjectProcedureId, procedure, completed, requiredCount];
}