import 'package:equatable/equatable.dart';
import '../../../domain/entities/assigned_patient_details_entity.dart';

enum AssignedPatientDetailsStatus { initial, loading, loaded, error }

/// Lifecycle of the "Submit Case Acceptance Request" action, kept separate from
/// the page's load [status] so submitting never rebuilds the whole screen.
enum RequestSubmission { idle, submitting, success, failure }

class AssignedPatientDetailsState extends Equatable {
  const AssignedPatientDetailsState({
    this.status = AssignedPatientDetailsStatus.initial,
    this.details,
    this.errorMessage,
    this.submission = RequestSubmission.idle,
  });

  final AssignedPatientDetailsStatus status;
  final AssignedPatientDetailsEntity? details;
  final String? errorMessage;
  final RequestSubmission submission;

  bool get isLoading =>
      status == AssignedPatientDetailsStatus.initial ||
      status == AssignedPatientDetailsStatus.loading;

  bool get hasError => status == AssignedPatientDetailsStatus.error;

  bool get isSubmitting => submission == RequestSubmission.submitting;

  AssignedPatientDetailsState copyWith({
    AssignedPatientDetailsStatus? status,
    AssignedPatientDetailsEntity? details,
    String? errorMessage,
    RequestSubmission? submission,
  }) {
    return AssignedPatientDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      errorMessage: errorMessage,
      submission: submission ?? this.submission,
    );
  }

  @override
  List<Object?> get props => [status, details, errorMessage, submission];
}