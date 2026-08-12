import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/available_procedure_entity.dart';
import '../../../domain/entities/case_acceptance_request_entity.dart';
import '../../../domain/entities/procedure_request_entity.dart';
import '../../../domain/entities/question_answer_entity.dart';
import '../../../domain/use_cases/get_subject_configuration_use_case.dart';
import '../../../domain/use_cases/submit_case_acceptance_request_use_case.dart';
import '../../models/case_acceptance_request_args.dart';
import 'case_acceptance_request_state.dart';

class CaseAcceptanceRequestCubit extends Cubit<CaseAcceptanceRequestState> {
  CaseAcceptanceRequestCubit({
    required GetSubjectConfigurationUseCase getSubjectConfiguration,
    required SubmitCaseAcceptanceRequestUseCase submitAcceptanceRequest,
    required this.args,
  })  : _getSubjectConfiguration = getSubjectConfiguration,
        _submitAcceptanceRequest = submitAcceptanceRequest,
        super(const CaseAcceptanceRequestState());

  final GetSubjectConfigurationUseCase _getSubjectConfiguration;
  final SubmitCaseAcceptanceRequestUseCase _submitAcceptanceRequest;
  final CaseAcceptanceRequestArgs args;

  Future<void> loadConfiguration({bool force = false}) async {
    if (!force &&
        (state.configStatus == ConfigStatus.loaded ||
            state.configStatus == ConfigStatus.loading)) {
      return;
    }
    emit(state.copyWith(configStatus: ConfigStatus.loading));
    final result = await _getSubjectConfiguration(args.subjectId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          configStatus: ConfigStatus.error,
          configError: failure.message,
        ),
      ),
      (config) => emit(
        state.copyWith(
          configStatus: ConfigStatus.loaded,
          config: config,
        ),
      ),
    );
  }


  void saveProcedureRequest({
    int? toothNumber,
    String? existingId,
    required AvailableProcedureEntity procedure,
    required List<QuestionAnswerEntity> answers,
    required String notes,
  }) {
    final localId = existingId ??
        (toothNumber != null ? 'tooth-$toothNumber' : _generateLocalId());

    final request = ProcedureRequestEntity(
      localId: localId,
      toothNumber: toothNumber,
      procedureId: procedure.id,
      procedureName: procedure.name,
      notes: notes.trim(),
      answers: answers,
    );

    final updated = [...state.requests];
    final index = updated.indexWhere((r) => r.localId == localId);
    if (index >= 0) {
      updated[index] = request;
    } else {
      updated.add(request);
    }
    emit(state.copyWith(requests: updated));
  }

  void removeRequest(String localId) {
    if (!state.requests.any((r) => r.localId == localId)) return;
    final updated =
        state.requests.where((r) => r.localId != localId).toList();
    emit(state.copyWith(requests: updated));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emit(state.copyWith(submission: RequestSubmission.submitting));

    final request = CaseAcceptanceRequestEntity(
      clinicalCaseId: args.clinicalCaseId,
      plannedProcedures: state.orderedRequests,
    );

    final result = await _submitAcceptanceRequest(request);
    result.fold(
      (failure) => emit(
        state.copyWith(
          submission: RequestSubmission.failure,
          submissionError: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(submission: RequestSubmission.success)),
    );
  }

  String _generateLocalId() =>
      DateTime.now().microsecondsSinceEpoch.toString();
}