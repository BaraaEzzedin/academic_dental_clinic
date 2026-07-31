import 'package:equatable/equatable.dart';
import '../../../domain/entities/assigned_patient_entity.dart';
import '../../models/patient_status_filter.dart';

enum PatientsStatus { initial, loading, loaded, error }

class PatientFilterState extends Equatable {
  const PatientFilterState({
    this.status = PatientsStatus.initial,
    this.selectedFilter = PatientStatusFilter.all,
    this.patients = const [],
    this.errorMessage,
  });

  final PatientsStatus status;
  final PatientStatusFilter selectedFilter;
  final List<AssignedPatientEntity> patients;
  final String? errorMessage;

  bool get isLoading => status == PatientsStatus.loading;
  bool get hasError => status == PatientsStatus.error;

  /// Patients matching the currently selected filter.
  List<AssignedPatientEntity> get filteredPatients =>
      patients.where((patient) => selectedFilter.matches(patient.status)).toList();

  PatientFilterState copyWith({
    PatientsStatus? status,
    PatientStatusFilter? selectedFilter,
    List<AssignedPatientEntity>? patients,
    String? errorMessage,
  }) {
    return PatientFilterState(
      status: status ?? this.status,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      patients: patients ?? this.patients,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, selectedFilter, patients, errorMessage];
}