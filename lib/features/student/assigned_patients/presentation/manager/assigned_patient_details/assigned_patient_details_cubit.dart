import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/assigned_patient_entity.dart';
import '../../../domain/use_cases/cancel_assigned_case_use_case.dart';
import '../../../domain/use_cases/get_assigned_case_details_use_case.dart';
import 'assigned_patient_details_state.dart';

class AssignedPatientDetailsCubit extends Cubit<AssignedPatientDetailsState> {
  AssignedPatientDetailsCubit(this._getDetails, this._cancelAssignedCase)
      : super(const AssignedPatientDetailsState());

  final GetAssignedCaseDetailsUseCase _getDetails;
  final CancelAssignedCaseUseCase _cancelAssignedCase;

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

  /// Releases the currently loaded assigned case back to open/unassigned.
  Future<void> cancelAssignment(int caseId) async {
    emit(state.copyWith(cancelStatus: CancelAssignedStatus.loading));

    final result = await _cancelAssignedCase(caseId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          cancelStatus: CancelAssignedStatus.error,
          cancelErrorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(cancelStatus: CancelAssignedStatus.success),
      ),
    );
  }
}
