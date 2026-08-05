import '../../domain/entities/today_appointment_entity.dart';

class TodayAppointmentModel extends TodayAppointmentEntity {
  const TodayAppointmentModel({
    required super.id,
    required super.patientName,
    required super.start,
    required super.displayStatus,
  });

  factory TodayAppointmentModel.fromJson(Map<String, dynamic> json) {
    return TodayAppointmentModel(
      id: (json['appointmentId'] as num).toInt(),
      patientName: json['patient'] as String? ?? '',
      start: json['start'] as String? ?? '',
      displayStatus: json['displayStatus'] as String? ?? '',
    );
  }
}