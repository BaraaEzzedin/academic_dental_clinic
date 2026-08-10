import 'package:equatable/equatable.dart';


class CaseAcceptanceRequestArgs extends Equatable {
  const CaseAcceptanceRequestArgs({
    required this.patientId,
    required this.patientName,
    required this.subjectId,
    required this.subjectName,
    required this.chiefComplaint,
  });

  final int patientId;
  final String patientName;
  final int subjectId;
  final String subjectName;
  final String chiefComplaint;

  @override
  List<Object?> get props => [
        patientId,
        patientName,
        subjectId,
        subjectName,
        chiefComplaint,
      ];
}