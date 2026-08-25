enum PatientStatus {
  waitingApproval,
  inTreatment,
  finalReview,
  completed,
}

extension PatientStatusX on PatientStatus {
  String get label => switch (this) {
        PatientStatus.waitingApproval => 'Waiting Approval',
        PatientStatus.inTreatment => 'In Treatment',
        PatientStatus.finalReview => 'Final Review',
        PatientStatus.completed => 'Completed',
      };

  /// Whether treatment actions (add session, upload media, edit progress,
  /// add materials, mark completed) are allowed. Only while in treatment;
  /// pending review and completed cases are read-only.
  bool get canEditTreatment => this == PatientStatus.inTreatment;
}