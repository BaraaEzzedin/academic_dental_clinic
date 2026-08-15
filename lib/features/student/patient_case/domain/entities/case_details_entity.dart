import 'package:equatable/equatable.dart';
import 'case_info_entity.dart';
import 'case_media_entity.dart';
import 'planned_procedure_entity.dart';
import 'supervisor_evaluation_entity.dart';
import 'supervisor_note_entity.dart';
import 'timeline_entry_entity.dart';

/// Aggregate payload of the Case Details screen (`GET /clinical-cases/my/{id}`).
class CaseDetailsEntity extends Equatable {
  const CaseDetailsEntity({
    required this.caseInfo,
    required this.targetTeeth,
    required this.materials,
    required this.media,
    required this.timeline,
    required this.supervisorNotes,
    this.evaluation,
  });

  final CaseInfoEntity caseInfo;
  final List<PlannedProcedureEntity> targetTeeth;
  final List<String> materials;
  final List<CaseMediaEntity> media;
  final List<TimelineEntryEntity> timeline;
  final List<SupervisorNoteEntity> supervisorNotes;

  /// The supervisor's final evaluation, or `null` until the case is evaluated.
  final SupervisorEvaluationEntity? evaluation;

  @override
  List<Object?> get props => [
        caseInfo,
        targetTeeth,
        materials,
        media,
        timeline,
        supervisorNotes,
        evaluation,
      ];
}
