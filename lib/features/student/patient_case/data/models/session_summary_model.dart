import '../../domain/entities/session_summary_entity.dart';

class SummaryTreatmentItemModel extends SummaryTreatmentItemEntity {
  const SummaryTreatmentItemModel({
    required super.procedureName,
    required super.toothNumber,
    required super.rawStatus,
  });

  factory SummaryTreatmentItemModel.fromJson(Map<String, dynamic> json) {
    return SummaryTreatmentItemModel(
      procedureName: json['procedureName'] as String? ?? '',
      toothNumber: (json['toothNumber'] as num?)?.toInt() ?? 0,
      rawStatus: json['status'] as String? ?? '',
    );
  }
}

class SessionSummaryModel extends SessionSummaryEntity {
  const SessionSummaryModel({
    required super.id,
    required super.title,
    required super.appointmentDate,
    required super.treatmentItems,
    required super.notes,
  });

  factory SessionSummaryModel.fromJson(Map<String, dynamic> json) {
    final items = json['treatmentItems'] as List<dynamic>? ?? const [];
    return SessionSummaryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      appointmentDate:
          DateTime.tryParse(json['appointmentDate'] as String? ?? ''),
      treatmentItems: items
          .whereType<Map<String, dynamic>>()
          .map(SummaryTreatmentItemModel.fromJson)
          .toList(),
      notes: json['notes'] as String? ?? '',
    );
  }
}
