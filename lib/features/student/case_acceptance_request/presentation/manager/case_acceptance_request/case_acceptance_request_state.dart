import 'package:equatable/equatable.dart';
import '../../../domain/entities/available_procedure_entity.dart';
import '../../../domain/entities/procedure_request_entity.dart';
import '../../../domain/entities/subject_config_entity.dart';
import '../../../domain/entities/subject_question_entity.dart';

enum ConfigStatus { initial, loading, loaded, error }

enum RequestSubmission { idle, submitting, success, failure }

class CaseAcceptanceRequestState extends Equatable {
  const CaseAcceptanceRequestState({
    this.configStatus = ConfigStatus.initial,
    this.config,
    this.configError,
    this.requests = const [],
    this.submission = RequestSubmission.idle,
    this.submissionError,
  });

  final ConfigStatus configStatus;
  final SubjectConfigEntity? config;
  final String? configError;

  /// Locally saved procedure requests (mock state, not yet submitted).
  final List<ProcedureRequestEntity> requests;

  final RequestSubmission submission;
  final String? submissionError;

  bool get isLoadingConfig =>
      configStatus == ConfigStatus.initial ||
      configStatus == ConfigStatus.loading;

  bool get hasConfigError => configStatus == ConfigStatus.error;

  bool get requiresDentalChart => config?.requiresDentalChart ?? false;

  List<AvailableProcedureEntity> get procedures =>
      config?.availableProcedures ?? const [];

  List<SubjectQuestionEntity> get questions =>
      config?.orderedQuestions ?? const [];

  Set<int> get selectedTeeth => {
        for (final request in requests)
          if (request.toothNumber != null) request.toothNumber!,
      };

  bool get hasRequests => requests.isNotEmpty;

  bool get isSubmitting => submission == RequestSubmission.submitting;

  bool get canSubmit => hasRequests && !isSubmitting;


  List<ProcedureRequestEntity> get orderedRequests {
    if (!requiresDentalChart) return requests;
    final list = [...requests]
      ..sort(
        (a, b) => (a.toothNumber ?? 0).compareTo(b.toothNumber ?? 0),
      );
    return list;
  }

  ProcedureRequestEntity? requestForTooth(int toothNumber) {
    for (final request in requests) {
      if (request.toothNumber == toothNumber) return request;
    }
    return null;
  }

  CaseAcceptanceRequestState copyWith({
    ConfigStatus? configStatus,
    SubjectConfigEntity? config,
    String? configError,
    List<ProcedureRequestEntity>? requests,
    RequestSubmission? submission,
    String? submissionError,
  }) {
    return CaseAcceptanceRequestState(
      configStatus: configStatus ?? this.configStatus,
      config: config ?? this.config,
      configError: configError,
      requests: requests ?? this.requests,
      submission: submission ?? this.submission,
      submissionError: submissionError,
    );
  }

  @override
  List<Object?> get props => [
        configStatus,
        config,
        configError,
        requests,
        submission,
        submissionError,
      ];
}