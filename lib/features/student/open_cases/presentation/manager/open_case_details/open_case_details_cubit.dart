import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/get_open_case_details_use_case.dart';
import 'open_case_details_state.dart';

class OpenCaseDetailsCubit extends Cubit<OpenCaseDetailsState> {
  OpenCaseDetailsCubit(this._getOpenCaseDetails)
      : super(const OpenCaseDetailsState());

  final GetOpenCaseDetailsUseCase _getOpenCaseDetails;

  /// Loads the full details for the open case with [caseId].
  Future<void> load(int caseId) async {
    emit(state.copyWith(status: OpenCaseDetailsStatus.loading));
    final result = await _getOpenCaseDetails(caseId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OpenCaseDetailsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (details) => emit(
        state.copyWith(
          status: OpenCaseDetailsStatus.loaded,
          details: details,
        ),
      ),
    );
  }
}