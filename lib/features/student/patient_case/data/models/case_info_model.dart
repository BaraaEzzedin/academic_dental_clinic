import '../../../../../core/utils/date_formatter.dart';
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
    required super.nextSessionDate,
    required super.nextSessionTime,
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
      nextSessionDate: _nextSessionDate(json['nextSession']),
      nextSessionTime: _nextSessionTime(json['nextSession']),
      rawStatus: json['status'] as String? ?? '',
    );
  }

  /// `nextSession` may arrive as a preformatted string, `null`, or an object
  /// (`{ appointmentDate, startTime }`). Returns the formatted date part
  /// (e.g. "Aug 16, 2026"); falls back to a plain string or empty.
  static String _nextSessionDate(dynamic raw) {
    if (raw is String) return raw;
    if (raw is Map<String, dynamic>) {
      return DateFormatter.mediumDateFromIso(raw['appointmentDate'] as String?);
    }
    return '';
  }

  /// Returns the formatted time part of `nextSession` (e.g. "11:00 AM"), or an
  /// empty string when the payload carries no time.
  static String _nextSessionTime(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return DateFormatter.toTimeOfDay(raw['startTime'] as String?);
    }
    return '';
  }
}
