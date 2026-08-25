import '../../domain/entities/today_appointment_entity.dart';
import '../mapper/clinical_appointment_status_mapper.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.clinicalCaseId,
    required super.patientName,
    required super.supervisorName,
    required super.date,
    required super.start,
    required super.end,
    required super.status,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: (json['appointmentId'] as num?)?.toInt() ?? 0,
      clinicalCaseId: (json['clinicalCaseId'] as num?)?.toInt() ?? 0,
      patientName: json['patientName'] as String? ?? '',
      supervisorName: json['supervisorName'] as String? ?? '',
      date: DateTime.tryParse(json['appointmentDate'] as String? ?? ''),
      start: json['appointmentStart'] as String? ?? '',
      end: json['appointmentEnd'] as String? ?? '',
      status: clinicalAppointmentStatusFromApi(json['status'] as String?),
    );
  }
}