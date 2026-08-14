import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/get_treatment_sessions_use_case.dart';
import '../../mapper/session_ui_mapper.dart';
import 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  SessionsCubit(this._getTreatmentSessions) : super(const SessionsState());

  final GetTreatmentSessionsUseCase _getTreatmentSessions;

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
}