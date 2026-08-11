import 'package:equatable/equatable.dart';
import 'question_answer_entity.dart';

class ProcedureRequestEntity extends Equatable {
  const ProcedureRequestEntity({
    required this.localId,
    required this.procedureId,
    required this.procedureName,
    this.toothNumber,
    this.notes = '',
    this.answers = const [],
  });

  final String localId;
  final int? toothNumber;
  final int procedureId;
  final String procedureName;
  final String notes;
  final List<QuestionAnswerEntity> answers;

  bool get hasTooth => toothNumber != null;
  bool get hasNotes => notes.trim().isNotEmpty;

  @override
  List<Object?> get props => [
        localId,
        toothNumber,
        procedureId,
        procedureName,
        notes,
        answers,
      ];
}