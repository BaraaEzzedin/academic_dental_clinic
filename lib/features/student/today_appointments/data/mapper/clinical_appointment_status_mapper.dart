import '../../../../../core/enums/clinical_appointment_status.dart';

/// Maps the backend `displayStatus` string to the
/// [ClinicalAppointmentStatus] enum.
///
/// Backend values (case/format insensitive):
/// - `scheduled` -> [ClinicalAppointmentStatus.scheduled]
/// - `completed` -> [ClinicalAppointmentStatus.completed]
/// - `cancelled` -> [ClinicalAppointmentStatus.cancelled]
/// - `no_show`   -> [ClinicalAppointmentStatus.noShow]
ClinicalAppointmentStatus clinicalAppointmentStatusFromApi(String? value) {
  final normalized = value?.toLowerCase().trim().replaceAll(' ', '_');
  return switch (normalized) {
    'scheduled' => ClinicalAppointmentStatus.scheduled,
    'completed' => ClinicalAppointmentStatus.completed,
    'cancelled' || 'canceled' => ClinicalAppointmentStatus.cancelled,
    'no_show' => ClinicalAppointmentStatus.noShow,
    _ => ClinicalAppointmentStatus.scheduled,
  };
}