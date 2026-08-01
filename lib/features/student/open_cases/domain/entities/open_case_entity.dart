import 'package:equatable/equatable.dart';

class OpenCaseEntity extends Equatable {
  const OpenCaseEntity({
    required this.id,
    required this.subjectId,
    required this.subject,
    required this.patientName,
    required this.chiefComplaint,
    this.coordinatorName,
    this.department,
  });

  final int id;
  final int subjectId;
  final String subject;
  final String patientName;
  final String chiefComplaint;
  final String? coordinatorName;
  final String? department;

  @override
  List<Object?> get props => [
        id,
        subjectId,
        subject,
        patientName,
        chiefComplaint,
        coordinatorName,
        department,
      ];
}