import 'package:equatable/equatable.dart';

class ToothProcedureEntity extends Equatable {
  const ToothProcedureEntity({
    required this.toothNumber,
    required this.procedureId,
    required this.procedureName,
  });


  final int toothNumber;
  final int procedureId;
  final String procedureName;

  @override
  List<Object?> get props => [toothNumber, procedureId, procedureName];
}