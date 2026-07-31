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
}