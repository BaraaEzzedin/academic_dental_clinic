import 'package:equatable/equatable.dart';
import '../../../domain/entities/open_case_details_entity.dart';

enum OpenCaseDetailsStatus { initial, loading, loaded, error }

class OpenCaseDetailsState extends Equatable {
  const OpenCaseDetailsState({
    this.status = OpenCaseDetailsStatus.initial,
    this.details,
    this.errorMessage,
  });

  final OpenCaseDetailsStatus status;
  final OpenCaseDetailsEntity? details;
  final String? errorMessage;

  bool get isLoading =>
      status == OpenCaseDetailsStatus.initial ||
      status == OpenCaseDetailsStatus.loading;

  bool get hasError => status == OpenCaseDetailsStatus.error;

  OpenCaseDetailsState copyWith({
    OpenCaseDetailsStatus? status,
    OpenCaseDetailsEntity? details,
    String? errorMessage,
  }) {
    return OpenCaseDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, details, errorMessage];
}