import 'package:equatable/equatable.dart';
import '../../models/session.dart';

enum SessionsStatus { initial, loading, loaded, error }

class SessionsState extends Equatable {
  const SessionsState({
    this.status = SessionsStatus.initial,
    this.sessions = const [],
    this.errorMessage,
  });

  final SessionsStatus status;
  final List<Session> sessions;
  final String? errorMessage;

  bool get isLoading =>
      status == SessionsStatus.initial || status == SessionsStatus.loading;

  bool get hasError => status == SessionsStatus.error;

  SessionsState copyWith({
    SessionsStatus? status,
    List<Session>? sessions,
    String? errorMessage,
  }) {
    return SessionsState(
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, sessions, errorMessage];
}