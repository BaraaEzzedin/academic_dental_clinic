import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/get_case_details_use_case.dart';
import 'case_details_state.dart';

class CaseDetailsCubit extends Cubit<CaseDetailsState> {
  CaseDetailsCubit(this._getCaseDetails) : super(const CaseDetailsState());

  final GetCaseDetailsUseCase _getCaseDetails;

  /// Loads the full details for the clinical case with [caseId].
  Future<void> load(int caseId) async {
    emit(state.copyWith(status: CaseDetailsStatus.loading));
    final result = await _getCaseDetails(caseId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CaseDetailsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (details) => emit(
        state.copyWith(
          status: CaseDetailsStatus.loaded,
          details: details,
        ),
      ),
    );
  }
}
