import 'package:equatable/equatable.dart';
import '../../../domain/entities/subject_details_entity.dart';

enum SubjectDetailsStatus { initial, loading, loaded, error }

class SubjectDetailsState extends Equatable {
  const SubjectDetailsState({
    this.status = SubjectDetailsStatus.initial,
    this.details,
    this.errorMessage,
  });

  final SubjectDetailsStatus status;
  final SubjectDetailsEntity? details;
  final String? errorMessage;

  bool get isLoading =>
      status == SubjectDetailsStatus.initial ||
      status == SubjectDetailsStatus.loading;

  bool get hasError => status == SubjectDetailsStatus.error;

  SubjectDetailsState copyWith({
    SubjectDetailsStatus? status,
    SubjectDetailsEntity? details,
    String? errorMessage,
  }) {
    return SubjectDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, details, errorMessage];
}
