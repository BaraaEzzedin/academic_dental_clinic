import 'package:equatable/equatable.dart';
import '../../../domain/entities/assigned_patient_details_entity.dart';

enum AssignedPatientDetailsStatus { initial, loading, loaded, error }

enum CancelAssignedStatus { initial, loading, success, error }

class AssignedPatientDetailsState extends Equatable {
  const AssignedPatientDetailsState({
    this.status = AssignedPatientDetailsStatus.initial,
    this.details,
    this.errorMessage,
    this.cancelStatus = CancelAssignedStatus.initial,
    this.cancelErrorMessage,
  });

  final AssignedPatientDetailsStatus status;
  final AssignedPatientDetailsEntity? details;
  final String? errorMessage;

  final CancelAssignedStatus cancelStatus;
  final String? cancelErrorMessage;

  bool get isLoading =>
      status == AssignedPatientDetailsStatus.initial ||
      status == AssignedPatientDetailsStatus.loading;

  bool get hasError => status == AssignedPatientDetailsStatus.error;

  bool get isCancelling => cancelStatus == CancelAssignedStatus.loading;

  AssignedPatientDetailsState copyWith({
    AssignedPatientDetailsStatus? status,
    AssignedPatientDetailsEntity? details,
    String? errorMessage,
    CancelAssignedStatus? cancelStatus,
    String? cancelErrorMessage,
  }) {
    return AssignedPatientDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      errorMessage: errorMessage,
      cancelStatus: cancelStatus ?? this.cancelStatus,
      cancelErrorMessage: cancelErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        details,
        errorMessage,
        cancelStatus,
        cancelErrorMessage,
      ];
}
