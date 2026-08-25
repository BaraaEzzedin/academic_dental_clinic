import 'package:equatable/equatable.dart';
import 'procedure_progress_entity.dart';
import 'subject_case_entity.dart';

/// Aggregate payload of the Subject Details screen
/// (`GET /students/me/subjects/{id}`): subject header, per-procedure progress
/// and the related patient cases.
class SubjectDetailsEntity extends Equatable {
  const SubjectDetailsEntity({
    required this.subjectId,
    required this.subject,
    required this.section,
    required this.supervisor,
    required this.procedures,
    required this.cases,
  });

  final int subjectId;
  final String subject;
  final String section;
  final String supervisor;
  final List<ProcedureProgressEntity> procedures;
  final List<SubjectCaseEntity> cases;

  /// Sum of completed across every procedure.
  int get totalCompleted =>
      procedures.fold(0, (sum, p) => sum + p.completed);

  /// Sum of required across every procedure.
  int get totalRequired =>
      procedures.fold(0, (sum, p) => sum + p.requiredCount);

  double get overallFraction {
    if (totalRequired <= 0) return 0;
    return (totalCompleted / totalRequired).clamp(0.0, 1.0);
  }

  int get overallPercent => (overallFraction * 100).round();

  @override
  List<Object?> get props =>
      [subjectId, subject, section, supervisor, procedures, cases];
}
