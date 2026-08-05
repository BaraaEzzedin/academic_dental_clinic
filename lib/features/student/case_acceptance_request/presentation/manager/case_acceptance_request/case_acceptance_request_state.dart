import 'package:equatable/equatable.dart';
import '../../../domain/entities/available_procedure_entity.dart';

enum ProceduresStatus { initial, loading, loaded, empty, error }

enum RequestSubmission { idle, submitting, success, failure }

class CaseAcceptanceRequestState extends Equatable {
  const CaseAcceptanceRequestState({
    this.proceduresStatus = ProceduresStatus.initial,
    this.procedures = const [],
    this.proceduresError,
    this.selections = const {},
    this.diagnosis = '',
    this.submission = RequestSubmission.idle,
    this.submissionError,
  });

  final ProceduresStatus proceduresStatus;
  final List<AvailableProcedureEntity> procedures;
  final String? proceduresError;

  final Map<int, AvailableProcedureEntity> selections;
  final String diagnosis;

  final RequestSubmission submission;
  final String? submissionError;

  bool get isLoadingProcedures =>
      proceduresStatus == ProceduresStatus.initial ||
      proceduresStatus == ProceduresStatus.loading;

  bool get hasProceduresError => proceduresStatus == ProceduresStatus.error;

  bool get hasSelections => selections.isNotEmpty;

  bool get isDiagnosisValid => diagnosis.trim().isNotEmpty;

  bool get isSubmitting => submission == RequestSubmission.submitting;

  bool get canSubmit => hasSelections && isDiagnosisValid && !isSubmitting;

  List<MapEntry<int, AvailableProcedureEntity>> get orderedSelections {
    final entries = selections.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return entries;
  }

  CaseAcceptanceRequestState copyWith({
    ProceduresStatus? proceduresStatus,
    List<AvailableProcedureEntity>? procedures,
    String? proceduresError,
    Map<int, AvailableProcedureEntity>? selections,
    String? diagnosis,
    RequestSubmission? submission,
    String? submissionError,
  }) {
    return CaseAcceptanceRequestState(
      proceduresStatus: proceduresStatus ?? this.proceduresStatus,
      procedures: procedures ?? this.procedures,
      proceduresError: proceduresError,
      selections: selections ?? this.selections,
      diagnosis: diagnosis ?? this.diagnosis,
      submission: submission ?? this.submission,
      submissionError: submissionError,
    );
  }

  @override
  List<Object?> get props => [
        proceduresStatus,
        procedures,
        proceduresError,
        selections,
        diagnosis,
        submission,
        submissionError,
      ];
}