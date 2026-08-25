import '../../domain/entities/treatment_session_entity.dart';

class TreatmentSessionModel extends TreatmentSessionEntity {
  const TreatmentSessionModel({
    required super.id,
    required super.title,
    required super.rawStatus,
    required super.notes,
    required super.appointmentDate,
    required super.startTime,
  });

  factory TreatmentSessionModel.fromJson(Map<String, dynamic> json) {
    return TreatmentSessionModel(
      id: (json['sessionId'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      rawStatus: json['status'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      appointmentDate:
          DateTime.tryParse(json['appointmentDate'] as String? ?? ''),
      startTime: json['startTime'] as String? ?? '',
    );
  }
}