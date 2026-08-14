import 'package:equatable/equatable.dart';

import '../../../domain/entities/session_summary_entity.dart';

enum SessionSummaryStatus { initial, loading, loaded, error }

class SessionSummaryState extends Equatable {
  const SessionSummaryState({
    this.status = SessionSummaryStatus.initial,
    this.summary,
    this.errorMessage,
  });

  final SessionSummaryStatus status;
  final SessionSummaryEntity? summary;
  final String? errorMessage;

  bool get isLoading =>
      status == SessionSummaryStatus.initial ||
      status == SessionSummaryStatus.loading;

  bool get hasError => status == SessionSummaryStatus.error;

  SessionSummaryState copyWith({
    SessionSummaryStatus? status,
    SessionSummaryEntity? summary,
    String? errorMessage,
  }) {
    return SessionSummaryState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, summary, errorMessage];
}
