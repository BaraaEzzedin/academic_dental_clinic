import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/get_treatment_sessions_use_case.dart';
import '../../../domain/use_cases/start_treatment_session_use_case.dart';
import '../../mapper/session_ui_mapper.dart';
import 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  SessionsCubit(this._getTreatmentSessions, this._startSession)
      : super(const SessionsState());

  final GetTreatmentSessionsUseCase _getTreatmentSessions;
  final StartTreatmentSessionUseCase _startSession;

  /// Loads the treatment sessions for the clinical case [clinicalCaseId].
  Future<void> load(int clinicalCaseId) async {
    emit(state.copyWith(status: SessionsStatus.loading));
    final result = await _getTreatmentSessions(clinicalCaseId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SessionsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (sessions) => emit(
        state.copyWith(
          status: SessionsStatus.loaded,
          sessions: sessions.map(sessionFromEntity).toList(),
        ),
      ),
    );
  }

  /// Starts the upcoming session [sessionId]. Returns `null` on success or the
  /// backend error message (e.g. the 409 window message) on failure. The caller
  /// controls the snackbar → reload order.
  Future<String?> startSession(int sessionId) async {
    final result = await _startSession(sessionId);
    return result.fold((failure) => failure.message, (_) => null);
  }
}