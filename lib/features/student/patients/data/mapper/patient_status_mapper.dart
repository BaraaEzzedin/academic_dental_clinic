import '../../../../../core/enums/patient_status.dart';

/// Maps the backend `status` string to the [PatientStatus] enum.
///
/// Backend values:
/// - `DIAGNOSIS_PENDING_REVIEW` -> [PatientStatus.waitingApproval]
/// - `TREATMENT_IN_PROGRESS` / `IN_TREATMENT` -> [PatientStatus.inTreatment]
/// - `AWAITING_CASE_REVIEW`     -> [PatientStatus.finalReview]
/// - `COMPLETED`                -> [PatientStatus.completed]
PatientStatus patientStatusFromApi(String? value) {
  return switch (value?.toUpperCase()) {
    'DIAGNOSIS_PENDING_REVIEW' => PatientStatus.waitingApproval,
    'TREATMENT_IN_PROGRESS' || 'IN_TREATMENT' => PatientStatus.inTreatment,
    'AWAITING_CASE_REVIEW' => PatientStatus.finalReview,
    'COMPLETED' => PatientStatus.completed,
    _ => PatientStatus.waitingApproval,
  };
}

String patientStatusToApi(PatientStatus status) => switch (status) {
      PatientStatus.waitingApproval => 'DIAGNOSIS_PENDING_REVIEW',
      PatientStatus.inTreatment => 'TREATMENT_IN_PROGRESS',
      PatientStatus.finalReview => 'AWAITING_CASE_REVIEW',
      PatientStatus.completed => 'COMPLETED',
    };