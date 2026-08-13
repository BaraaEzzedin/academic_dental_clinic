import '../../domain/entities/case_info_entity.dart';

class CaseInfoModel extends CaseInfoEntity {
  const CaseInfoModel({
    required super.patientId,
    required super.patientName,
    required super.patientAge,
    required super.patientGender,
    required super.subjectId,
    required super.subjectName,
    required super.requiresDentalChart,
    required super.supervisor,
    required super.nextSession,
    required super.rawStatus,
  });

  factory CaseInfoModel.fromJson(Map<String, dynamic> json) {
    final subject = json['subject'] as Map<String, dynamic>? ?? const {};
    return CaseInfoModel(
      patientId: (json['patientId'] as num?)?.toInt() ?? 0,
      patientName: json['patientName'] as String? ?? '',
      patientAge: (json['patientAge'] as num?)?.toInt() ?? 0,
      patientGender: json['patientGender'] as String? ?? '',
      subjectId: (subject['id'] as num?)?.toInt() ?? 0,
      subjectName: subject['name'] as String? ?? '',
      // Backend now includes the flag inside `subject`; fall back to a flat
      // `requiresDentalChart` on `caseInfo` just in case.
      requiresDentalChart: subject['requiresDentalChart'] as bool? ??
          json['requiresDentalChart'] as bool? ??
          false,
      supervisor: json['supervisor'] as String? ?? '',
      nextSession: json['nextSession'] as String? ?? '',
      rawStatus: json['status'] as String? ?? '',
    );
  }
}
