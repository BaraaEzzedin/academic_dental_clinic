import 'package:equatable/equatable.dart';
import '../../models/assigned_patient.dart';

class PatientFilterState extends Equatable {
  const PatientFilterState({
    this.selectedFilter = PatientStatusFilter.all,
    this.patients = const [],
  });

  final PatientStatusFilter selectedFilter;
  final List<AssignedPatient> patients;

  /// Patients matching the currently selected filter.
  List<AssignedPatient> get filteredPatients =>
      patients.where((patient) => selectedFilter.matches(patient.status)).toList();

  PatientFilterState copyWith({
    PatientStatusFilter? selectedFilter,
    List<AssignedPatient>? patients,
  }) {
    return PatientFilterState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      patients: patients ?? this.patients,
    );
  }

  @override
  List<Object?> get props => [selectedFilter, patients];
}