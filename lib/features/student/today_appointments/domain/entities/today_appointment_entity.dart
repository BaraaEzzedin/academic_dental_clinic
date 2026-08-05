import 'package:equatable/equatable.dart';

import '../../../../../core/enums/clinical_appointment_status.dart';

class TodayAppointmentEntity extends Equatable {
  const TodayAppointmentEntity({
    required this.id,
    required this.patientName,
    required this.subject,
    required this.clinic,
    required this.start,
    required this.status,
  });

  final int id;
  final String patientName;
  final String subject;
  final String clinic;
  final String start;
  final ClinicalAppointmentStatus status;

  @override
  List<Object?> get props => [id, patientName, subject, clinic, start, status];
}