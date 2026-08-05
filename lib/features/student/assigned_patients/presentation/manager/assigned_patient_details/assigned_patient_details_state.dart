import 'package:equatable/equatable.dart';
import '../../../domain/entities/assigned_patient_details_entity.dart';

enum AssignedPatientDetailsStatus { initial, loading, loaded, error }

class AssignedPatientDetailsState extends Equatable {
  const AssignedPatientDetailsState({
    this.status = AssignedPatientDetailsStatus.initial,
    this.details,
    this.errorMessage,
  });

  final AssignedPatientDetailsStatus status;
  final AssignedPatientDetailsEntity? details;
  final String? errorMessage;

  bool get isLoading =>
      status == AssignedPatientDetailsStatus.initial ||
      status == AssignedPatientDetailsStatus.loading;

  bool get hasError => status == AssignedPatientDetailsStatus.error;

  AssignedPatientDetailsState copyWith({
    AssignedPatientDetailsStatus? status,
    AssignedPatientDetailsEntity? details,
    String? errorMessage,
  }) {
    return AssignedPatientDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, details, errorMessage];
}