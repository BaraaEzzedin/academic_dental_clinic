enum PatientStatus {
  waitingApproval,
  inTreatment,
  completed,
}

extension PatientStatusX on PatientStatus {
  String get label => switch (this) {
        PatientStatus.waitingApproval => 'Waiting Approval',
        PatientStatus.inTreatment => 'In Treatment',
        PatientStatus.completed => 'Completed',
      };
}