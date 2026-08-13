import 'package:equatable/equatable.dart';
import '../../../domain/entities/case_details_entity.dart';

enum CaseDetailsStatus { initial, loading, loaded, error }

class CaseDetailsState extends Equatable {
  const CaseDetailsState({
    this.status = CaseDetailsStatus.initial,
    this.details,
    this.errorMessage,
  });

  final CaseDetailsStatus status;
  final CaseDetailsEntity? details;
  final String? errorMessage;

  bool get isLoading =>
      status == CaseDetailsStatus.initial ||
      status == CaseDetailsStatus.loading;

  bool get hasError => status == CaseDetailsStatus.error;

  CaseDetailsState copyWith({
    CaseDetailsStatus? status,
    CaseDetailsEntity? details,
    String? errorMessage,
  }) {
    return CaseDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, details, errorMessage];
}
