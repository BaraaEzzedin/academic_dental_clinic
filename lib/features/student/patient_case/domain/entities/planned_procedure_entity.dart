import 'package:equatable/equatable.dart';
import 'procedure_answer_entity.dart';

/// One planned procedure from `treatmentPlan.targetTeeth`. [tooth] is `null`
/// for subjects that do not use a dental chart (procedure-based workflow).
class PlannedProcedureEntity extends Equatable {
  const PlannedProcedureEntity({
    required this.procedure,
    this.tooth,
    this.rawStatus,
    this.notes,
    this.answers = const [],
  });

  final String procedure;
  final int? tooth;
  final String? rawStatus;
  final String? notes;
  final List<ProcedureAnswerEntity> answers;

  @override
  List<Object?> get props => [procedure, tooth, rawStatus, notes, answers];
}
