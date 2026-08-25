import 'package:equatable/equatable.dart';
import 'available_procedure_entity.dart';
import 'subject_question_entity.dart';

class SubjectConfigEntity extends Equatable {
  const SubjectConfigEntity({
    required this.subjectId,
    required this.subjectName,
    required this.requiresDentalChart,
    required this.availableProcedures,
    required this.questions,
  });

  final int subjectId;
  final String subjectName;
  final bool requiresDentalChart;
  final List<AvailableProcedureEntity> availableProcedures;
  final List<SubjectQuestionEntity> questions;

  List<SubjectQuestionEntity> get orderedQuestions {
    final list = [...questions]
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return list;
  }

  @override
  List<Object?> get props => [
        subjectId,
        subjectName,
        requiresDentalChart,
        availableProcedures,
        questions,
      ];
}