enum ClinicalAppointmentStatus {
  scheduled,
  completed,
  cancelled,
  noShow,
}

extension ClinicalAppointmentStatusX on ClinicalAppointmentStatus {
  String get label => switch (this) {
        ClinicalAppointmentStatus.scheduled => 'Scheduled',
        ClinicalAppointmentStatus.completed => 'Completed',
        ClinicalAppointmentStatus.cancelled => 'Cancelled',
        ClinicalAppointmentStatus.noShow => 'No Show',
      };
}