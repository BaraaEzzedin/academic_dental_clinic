import 'package:equatable/equatable.dart';

import '../../../../../core/enums/clinical_appointment_status.dart';

/// A single clinical appointment, shared by the schedule's "today" and
/// "upcoming" groups (`/clinical-appointments/student-upcoming`).
class AppointmentEntity extends Equatable {
  const AppointmentEntity({
    required this.id,
    required this.clinicalCaseId,
    required this.patientName,
    required this.supervisorName,
    required this.date,
    required this.start,
    required this.end,
    required this.status,
  });

  final int id;
  final int clinicalCaseId;
  final String patientName;
  final String supervisorName;

  /// Appointment day, parsed from `appointmentDate`. Null if unparseable.
  final DateTime? date;

  /// Raw `HH:mm[:ss]` start/end times, formatted for display in the UI.
  final String start;
  final String end;

  final ClinicalAppointmentStatus status;

  @override
  List<Object?> get props =>
      [id, clinicalCaseId, patientName, supervisorName, date, start, end, status];
}