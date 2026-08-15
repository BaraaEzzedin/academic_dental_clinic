import '../../domain/entities/case_subject_entity.dart';
import '../../domain/entities/open_case_entity.dart';

class OpenCaseModel extends OpenCaseEntity {
  const OpenCaseModel({
    required super.id,
    required super.subjectId,
    required super.subject,
    required super.patientName,
    required super.chiefComplaint,
    super.coordinatorName,
    super.department,
  });

  factory OpenCaseModel.fromJson(Map<String, dynamic> json) {
    final clinic = json['clinic'] as Map<String, dynamic>?;
    // `subject` is a nested object: { id, name, requiresDentalChart }.
    final subject = json['subject'] as Map<String, dynamic>?;
    return OpenCaseModel(
      id: (json['id'] as num).toInt(),
      subjectId: (subject?['id'] as num?)?.toInt() ?? CaseSubjectEntity.allId,
      subject: subject?['name'] as String? ?? '',
      patientName: json['patient'] as String? ?? '',
      chiefComplaint: json['chiefComplaint'] as String? ?? '',
      coordinatorName: json['coordinator'] as String?,
      department: clinic?['name'] as String?,
    );
  }
}