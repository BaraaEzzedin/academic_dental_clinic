import 'package:equatable/equatable.dart';
import '../../../domain/entities/assigned_patient_entity.dart';

enum AssignedPatientsStatus { initial, loading, loaded, error }

class AssignedPatientsState extends Equatable {
  const AssignedPatientsState({
    this.status = AssignedPatientsStatus.initial,
    this.patients = const [],
    this.errorMessage,
  });

  final AssignedPatientsStatus status;
  final List<AssignedPatientEntity> patients;
  final String? errorMessage;

  bool get isLoading => status == AssignedPatientsStatus.loading;
  bool get hasError => status == AssignedPatientsStatus.error;
  bool get isEmpty =>
      status == AssignedPatientsStatus.loaded && patients.isEmpty;
  bool get hasPatients =>
      status == AssignedPatientsStatus.loaded && patients.isNotEmpty;

  AssignedPatientsState copyWith({
    AssignedPatientsStatus? status,
    List<AssignedPatientEntity>? patients,
    String? errorMessage,
  }) {
    return AssignedPatientsState(
      status: status ?? this.status,
      patients: patients ?? this.patients,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, patients, errorMessage];
}