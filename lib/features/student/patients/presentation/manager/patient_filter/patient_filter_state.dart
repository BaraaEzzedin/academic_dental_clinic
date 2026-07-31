import 'package:equatable/equatable.dart';
import '../../../domain/entities/assigned_patient_entity.dart';
import '../../models/patient_status_filter.dart';

class PatientFilterState extends Equatable {
  const PatientFilterState({
    this.selectedFilter = PatientStatusFilter.all,
    this.patients = const [],
  });

  final PatientStatusFilter selectedFilter;
  final List<AssignedPatientEntity> patients;

  /// Patients matching the currently selected filter.
  List<AssignedPatientEntity> get filteredPatients =>
      patients.where((patient) => selectedFilter.matches(patient.status)).toList();

  PatientFilterState copyWith({
    PatientStatusFilter? selectedFilter,
    List<AssignedPatientEntity>? patients,
  }) {
    return PatientFilterState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      patients: patients ?? this.patients,
    );
  }

  @override
  List<Object?> get props => [selectedFilter, patients];
}