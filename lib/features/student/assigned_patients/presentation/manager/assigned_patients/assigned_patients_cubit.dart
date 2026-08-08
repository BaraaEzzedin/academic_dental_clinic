import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/get_assigned_cases_use_case.dart';
import 'assigned_patients_state.dart';

class AssignedPatientsCubit extends Cubit<AssignedPatientsState> {
  AssignedPatientsCubit(this._getAssignedCases)
      : super(const AssignedPatientsState());

  final GetAssignedCasesUseCase _getAssignedCases;

  Future<void> loadAssignedPatients() async {
    emit(state.copyWith(status: AssignedPatientsStatus.loading));

    final result = await _getAssignedCases();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AssignedPatientsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (patients) => emit(
        state.copyWith(
          status: AssignedPatientsStatus.loaded,
          patients: patients,
        ),
      ),
    );
  }
}