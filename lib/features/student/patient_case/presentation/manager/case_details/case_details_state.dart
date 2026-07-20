import 'package:equatable/equatable.dart';
import '../../models/case_details.dart';

enum CaseDetailsStatus { initial, loading, loaded, error }

class CaseDetailsState extends Equatable {
  const CaseDetailsState({
    this.status = CaseDetailsStatus.initial,
    this.details,
    this.errorMessage,
  });

  final CaseDetailsStatus status;
  final CaseDetails? details;
  final String? errorMessage;

  bool get isLoading =>
      status == CaseDetailsStatus.initial ||
      status == CaseDetailsStatus.loading;

  CaseDetailsState copyWith({
    CaseDetailsStatus? status,
    CaseDetails? details,
    String? errorMessage,
  }) {
    return CaseDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, details, errorMessage];
}