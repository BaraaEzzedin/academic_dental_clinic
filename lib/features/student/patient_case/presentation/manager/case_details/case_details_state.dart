import 'package:equatable/equatable.dart';
import '../../../domain/entities/case_details_entity.dart';
import '../../models/session.dart';

enum CaseDetailsStatus { initial, loading, loaded, error }

class CaseDetailsState extends Equatable {
  const CaseDetailsState({
    this.status = CaseDetailsStatus.initial,
    this.details,
    this.sessions = const [],
    this.errorMessage,
  });

  final CaseDetailsStatus status;
  final CaseDetailsEntity? details;

  /// Treatment sessions for this case, driving the Progress Timeline preview.
  final List<Session> sessions;
  final String? errorMessage;

  bool get isLoading =>
      status == CaseDetailsStatus.initial ||
      status == CaseDetailsStatus.loading;

  bool get hasError => status == CaseDetailsStatus.error;

  CaseDetailsState copyWith({
    CaseDetailsStatus? status,
    CaseDetailsEntity? details,
    List<Session>? sessions,
    String? errorMessage,
  }) {
    return CaseDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      sessions: sessions ?? this.sessions,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, details, sessions, errorMessage];
}
