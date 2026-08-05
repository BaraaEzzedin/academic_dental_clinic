import 'package:equatable/equatable.dart';
import 'tooth_procedure_entity.dart';


class CaseAcceptanceRequestEntity extends Equatable {
  const CaseAcceptanceRequestEntity({
    required this.patientId,
    required this.subjectId,
    required this.selections,
    required this.diagnosis,
  });

  final int patientId;
  final int subjectId;
  final List<ToothProcedureEntity> selections;
  final String diagnosis;

  @override
  List<Object?> get props => [patientId, subjectId, selections, diagnosis];
}