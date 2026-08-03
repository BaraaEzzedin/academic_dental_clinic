import 'package:flutter_bloc/flutter_bloc.dart';
import '../../mock/mock_assigned_patients.dart';
import 'assigned_patients_state.dart';

class AssignedPatientsCubit extends Cubit<AssignedPatientsState> {
  AssignedPatientsCubit() : super(const AssignedPatientsState());

  /// TODO(backend): replace the mock data below with a
  /// `GetAssignedPatientsUseCase` call once the API is ready. The state shape
  /// and the widgets stay the same — only this method changes.
  Future<void> loadAssignedPatients() async {
    emit(state.copyWith(status: AssignedPatientsStatus.loading));

    // Simulated network latency so the loading shimmer is visible with mocks.
    await Future<void>.delayed(const Duration(seconds: 2));

    emit(
      state.copyWith(
        status: AssignedPatientsStatus.loaded,
        patients: mockAssignedPatients,
      ),
    );
  }
}