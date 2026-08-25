import '../../domain/entities/procedure_progress_entity.dart';
import '../../domain/entities/subject_case_entity.dart';
import '../../domain/entities/subject_details_entity.dart';

class ProcedureProgressModel extends ProcedureProgressEntity {
  const ProcedureProgressModel({
    required super.subjectProcedureId,
    required super.procedure,
    required super.completed,
    required super.requiredCount,
  });

  factory ProcedureProgressModel.fromJson(Map<String, dynamic> json) {
    return ProcedureProgressModel(
      subjectProcedureId: (json['subjectProcedureId'] as num?)?.toInt() ?? 0,
      procedure: json['procedure'] as String? ?? '',
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      requiredCount: (json['required'] as num?)?.toInt() ?? 0,
    );
  }
}

class SubjectCaseModel extends SubjectCaseEntity {
  const SubjectCaseModel({
    required super.id,
    required super.patientName,
    required super.subjectName,
    required super.rawStatus,
    required super.sessionCount,
  });

  factory SubjectCaseModel.fromJson(Map<String, dynamic> json) {
    return SubjectCaseModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      patientName: json['patientName'] as String? ?? '',
      subjectName: json['subjectName'] as String? ?? '',
      rawStatus: json['status'] as String? ?? '',
      sessionCount: (json['sessionCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class SubjectDetailsModel extends SubjectDetailsEntity {
  const SubjectDetailsModel({
    required super.subjectId,
    required super.subject,
    required super.section,
    required super.supervisor,
    required super.procedures,
    required super.cases,
  });

  factory SubjectDetailsModel.fromJson(Map<String, dynamic> json) {
    final procedures = json['procedures'] as List<dynamic>? ?? const [];
    final cases = json['cases'] as List<dynamic>? ?? const [];
    return SubjectDetailsModel(
      subjectId: (json['subjectId'] as num?)?.toInt() ?? 0,
      subject: json['subject'] as String? ?? '',
      section: json['section'] as String? ?? '',
      supervisor: json['supervisor'] as String? ?? '',
      procedures: procedures
          .whereType<Map<String, dynamic>>()
          .map(ProcedureProgressModel.fromJson)
          .toList(),
      cases: cases
          .whereType<Map<String, dynamic>>()
          .map(SubjectCaseModel.fromJson)
          .toList(),
    );
  }
}
