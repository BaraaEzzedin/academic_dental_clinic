import '../../../../../core/enums/patient_status.dart';

enum PatientStatusFilter {
  all,
  waitingApproval,
  inTreatment,
  finalReview,
  completed,
}

extension PatientStatusFilterX on PatientStatusFilter {
  String get label => switch (this) {
        PatientStatusFilter.all => 'All',
        PatientStatusFilter.waitingApproval => 'Waiting Approval',
        PatientStatusFilter.inTreatment => 'In Treatment',
        PatientStatusFilter.finalReview => 'Final Review',
        PatientStatusFilter.completed => 'Completed',
      };

  bool matches(PatientStatus status) => switch (this) {
        PatientStatusFilter.all => true,
        PatientStatusFilter.waitingApproval =>
          status == PatientStatus.waitingApproval,
        PatientStatusFilter.inTreatment => status == PatientStatus.inTreatment,
        PatientStatusFilter.finalReview => status == PatientStatus.finalReview,
        PatientStatusFilter.completed => status == PatientStatus.completed,
      };
}