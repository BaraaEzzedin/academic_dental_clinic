import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/get_case_details_use_case.dart';
import '../../../domain/use_cases/get_treatment_sessions_use_case.dart';
import '../../mapper/session_ui_mapper.dart';
import '../../models/session.dart';
import 'case_details_state.dart';

class CaseDetailsCubit extends Cubit<CaseDetailsState> {
  CaseDetailsCubit(this._getCaseDetails, this._getTreatmentSessions)
      : super(const CaseDetailsState());

  final GetCaseDetailsUseCase _getCaseDetails;
  final GetTreatmentSessionsUseCase _getTreatmentSessions;

  /// Loads the full details for the clinical case with [caseId] together with
  /// its treatment sessions (which drive the Progress Timeline preview). Both
  /// requests run in parallel; a sessions failure is non-fatal and simply
  /// leaves the timeline empty.
  Future<void> load(int caseId) async {
    emit(state.copyWith(status: CaseDetailsStatus.loading));

    final detailsFuture = _getCaseDetails(caseId);
    final sessionsFuture = _getTreatmentSessions(caseId);
    final detailsResult = await detailsFuture;
    final sessionsResult = await sessionsFuture;

    detailsResult.fold(
      (failure) => emit(
        state.copyWith(
          status: CaseDetailsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (details) {
        final sessions = sessionsResult.fold(
          (_) => const <Session>[],
          (list) => list.map(sessionFromEntity).toList(),
        );
        emit(
          state.copyWith(
            status: CaseDetailsStatus.loaded,
            details: details,
            sessions: sessions,
          ),
        );
      },
    );
  }
}
