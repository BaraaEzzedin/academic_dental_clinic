import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/assigned_patient_entity.dart';
import '../../../domain/use_cases/get_assigned_case_details_use_case.dart';
import 'assigned_patient_details_state.dart';

class AssignedPatientDetailsCubit extends Cubit<AssignedPatientDetailsState> {
  AssignedPatientDetailsCubit(this._getDetails)
      : super(const AssignedPatientDetailsState());

  final GetAssignedCaseDetailsUseCase _getDetails;

  Future<void> load(AssignedPatientEntity patient) async {
    emit(state.copyWith(status: AssignedPatientDetailsStatus.loading));

    final result = await _getDetails(patient.id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AssignedPatientDetailsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (details) => emit(
        state.copyWith(
          status: AssignedPatientDetailsStatus.loaded,
          details: details,
        ),
      ),
    );
  }
}