import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/get_session_summary_use_case.dart';
import 'session_summary_state.dart';

class SessionSummaryCubit extends Cubit<SessionSummaryState> {
  SessionSummaryCubit(this._getSessionSummary)
      : super(const SessionSummaryState());

  final GetSessionSummaryUseCase _getSessionSummary;

  Future<void> load(int sessionId) async {
    emit(state.copyWith(status: SessionSummaryStatus.loading));
    final result = await _getSessionSummary(sessionId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: SessionSummaryStatus.error,
        errorMessage: failure.message,
      )),
      (summary) => emit(state.copyWith(
        status: SessionSummaryStatus.loaded,
        summary: summary,
      )),
    );
  }
}
