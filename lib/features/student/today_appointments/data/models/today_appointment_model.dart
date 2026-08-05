import '../../domain/entities/today_appointment_entity.dart';
import '../mapper/clinical_appointment_status_mapper.dart';

class TodayAppointmentModel extends TodayAppointmentEntity {
  const TodayAppointmentModel({
    required super.id,
    required super.patientName,
    required super.subject,
    required super.clinic,
    required super.start,
    required super.status,
  });

  factory TodayAppointmentModel.fromJson(Map<String, dynamic> json) {
    return TodayAppointmentModel(
      id: (json['appointmentId'] as num).toInt(),
      patientName: json['patient'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      clinic: json['clinic'] as String? ?? '',
      start: json['start'] as String? ?? '',
      status: clinicalAppointmentStatusFromApi(json['displayStatus'] as String?),
    );
  }
}