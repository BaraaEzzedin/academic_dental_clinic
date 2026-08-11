import 'package:equatable/equatable.dart';


class CaseAcceptanceRequestArgs extends Equatable {
  const CaseAcceptanceRequestArgs({
    required this.patientId,
    required this.patientName,
    required this.subjectId,
    required this.subjectName,
    required this.chiefComplaint,
    this.supervisorName = '',
    this.section = '',
  });

  final int patientId;
  final String patientName;
  final int subjectId;
  final String subjectName;
  final String chiefComplaint;

  final String supervisorName;

  final String section;

  @override
  List<Object?> get props => [
        patientId,
        patientName,
        subjectId,
        subjectName,
        chiefComplaint,
        supervisorName,
        section,
      ];
}