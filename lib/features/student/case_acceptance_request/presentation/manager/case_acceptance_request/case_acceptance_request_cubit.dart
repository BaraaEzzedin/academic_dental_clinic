import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/available_procedure_entity.dart';
import '../../../domain/entities/case_acceptance_request_entity.dart';
import '../../../domain/entities/tooth_procedure_entity.dart';
import '../../../domain/use_cases/get_available_procedures_use_case.dart';
import '../../../domain/use_cases/submit_case_acceptance_request_use_case.dart';
import '../../models/case_acceptance_request_args.dart';
import 'case_acceptance_request_state.dart';

class CaseAcceptanceRequestCubit extends Cubit<CaseAcceptanceRequestState> {
  CaseAcceptanceRequestCubit({
    required GetAvailableProceduresUseCase getAvailableProcedures,
    required SubmitCaseAcceptanceRequestUseCase submitAcceptanceRequest,
    required this.args,
  })  : _getAvailableProcedures = getAvailableProcedures,
        _submitAcceptanceRequest = submitAcceptanceRequest,
        super(const CaseAcceptanceRequestState());

  final GetAvailableProceduresUseCase _getAvailableProcedures;
  final SubmitCaseAcceptanceRequestUseCase _submitAcceptanceRequest;
  final CaseAcceptanceRequestArgs args;


  Future<void> loadProcedures({bool force = false}) async {
    if (!force &&
        (state.proceduresStatus == ProceduresStatus.loaded ||
            state.proceduresStatus == ProceduresStatus.loading)) {
      return;
    }
    emit(state.copyWith(proceduresStatus: ProceduresStatus.loading));
    final result = await _getAvailableProcedures(args.subjectId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          proceduresStatus: ProceduresStatus.error,
          proceduresError: failure.message,
        ),
      ),
      (procedures) => emit(
        state.copyWith(
          proceduresStatus: procedures.isEmpty
              ? ProceduresStatus.empty
              : ProceduresStatus.loaded,
          procedures: procedures,
        ),
      ),
    );
  }


  void assignProcedure(int toothNumber, AvailableProcedureEntity procedure) {
    final updated =
        Map<int, AvailableProcedureEntity>.from(state.selections)
          ..[toothNumber] = procedure;
    emit(state.copyWith(selections: updated));
  }


  void removeSelection(int toothNumber) {
    if (!state.selections.containsKey(toothNumber)) return;
    final updated =
        Map<int, AvailableProcedureEntity>.from(state.selections)
          ..remove(toothNumber);
    emit(state.copyWith(selections: updated));
  }

  void diagnosisChanged(String value) {
    emit(state.copyWith(diagnosis: value));
  }


  Future<void> submit() async {
    if (!state.canSubmit) return;
    emit(state.copyWith(submission: RequestSubmission.submitting));

    final request = CaseAcceptanceRequestEntity(
      patientId: args.patientId,
      subjectId: args.subjectId,
      diagnosis: state.diagnosis.trim(),
      selections: [
        for (final entry in state.orderedSelections)
          ToothProcedureEntity(
            toothNumber: entry.key,
            procedureId: entry.value.id,
            procedureName: entry.value.name,
          ),
      ],
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
}