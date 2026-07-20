import '../../../../../core/widgets/status_badge.dart';


enum PatientStatusFilter {
  all,
  waitingApproval,
  inTreatment,
  completed,
}

extension PatientStatusFilterX on PatientStatusFilter {
  String get label => switch (this) {
        PatientStatusFilter.all => 'All',
        PatientStatusFilter.waitingApproval => 'Waiting Approval',
        PatientStatusFilter.inTreatment => 'In Treatment',
        PatientStatusFilter.completed => 'Completed',
      };

  bool matches(PatientStatus status) => switch (this) {
        PatientStatusFilter.all => true,
        PatientStatusFilter.waitingApproval =>
          status == PatientStatus.waitingApproval,
        PatientStatusFilter.inTreatment => status == PatientStatus.inTreatment,
        PatientStatusFilter.completed => status == PatientStatus.completed,
      };
}

// model for ui , edit when backend is ready
class AssignedPatient {
  const AssignedPatient({
    required this.patientName,
    required this.subject,
    required this.procedure,
    required this.sessionNumber,
    required this.status,
  });

  final String patientName;
  final String subject;
  final String procedure;
  final int sessionNumber;
  final PatientStatus status;
}