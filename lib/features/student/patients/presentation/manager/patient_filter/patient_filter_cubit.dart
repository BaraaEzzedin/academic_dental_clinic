import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/get_assigned_patients_use_case.dart';
import '../../models/patient_status_filter.dart';
import 'patient_filter_state.dart';


class PatientFilterCubit extends Cubit<PatientFilterState> {
  PatientFilterCubit(this._getAssignedPatients)
      : super(const PatientFilterState());

  final GetAssignedPatientsUseCase _getAssignedPatients;

  Future<void> loadPatients() async {
    emit(state.copyWith(status: PatientsStatus.loading));
    final result = await _getAssignedPatients();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PatientsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (patients) => emit(
        state.copyWith(
          status: PatientsStatus.loaded,
          patients: patients,
        ),
      ),
    );
  }

  void selectFilter(PatientStatusFilter filter) {
    if (filter == state.selectedFilter) return;
    emit(state.copyWith(selectedFilter: filter));
  }
}