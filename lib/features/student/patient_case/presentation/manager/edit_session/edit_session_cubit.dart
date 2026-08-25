import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/treatment_sessions_repository.dart';
import '../../../domain/use_cases/complete_treatment_session_use_case.dart';
import '../../../domain/use_cases/get_materials_use_case.dart';
import '../../../domain/use_cases/get_planned_procedures_use_case.dart';
import '../../models/session_procedure_status.dart';
import 'edit_session_state.dart';

/// Drives the "Edit Session" sheet: loads the session's planned procedures and
/// the subject's materials, tracks local status edits + material selection, and
/// completes the session.
class EditSessionCubit extends Cubit<EditSessionState> {
  EditSessionCubit({
    required GetPlannedProceduresUseCase getPlannedProcedures,
    required GetMaterialsUseCase getMaterials,
    required CompleteTreatmentSessionUseCase completeSession,
    required this.treatmentSessionId,
    required this.subjectId,
  })  : _getPlannedProcedures = getPlannedProcedures,
        _getMaterials = getMaterials,
        _completeSession = completeSession,
        super(const EditSessionState());

  final GetPlannedProceduresUseCase _getPlannedProcedures;
  final GetMaterialsUseCase _getMaterials;
  final CompleteTreatmentSessionUseCase _completeSession;

  final int treatmentSessionId;
  final int subjectId;

  /// Loads the planned procedures and the subject's materials in parallel.
  Future<void> load() async {
    emit(state.copyWith(
      status: EditSessionStatus.loading,
      materialsStatus: MaterialsStatus.loading,
    ));

    final proceduresFuture = _getPlannedProcedures(treatmentSessionId);
    final materialsFuture = _getMaterials(subjectId);
    final proceduresResult = await proceduresFuture;
    final materialsResult = await materialsFuture;

    if (isClosed) return;

    var next = state;
    next = proceduresResult.fold(
      (failure) => next.copyWith(
        status: EditSessionStatus.error,
        errorMessage: failure.message,
      ),
      (data) => next.copyWith(status: EditSessionStatus.loaded, data: data),
    );
    next = materialsResult.fold(
      (_) => next.copyWith(materialsStatus: MaterialsStatus.error),
      (materials) => next.copyWith(
        materialsStatus: MaterialsStatus.loaded,
        materials: materials,
      ),
    );
    emit(next);
  }

  void setStatus(int procedureId, SessionProcedureStatus status) {
    emit(state.copyWith(
      editedStatuses: {...state.editedStatuses, procedureId: status},
    ));
  }

  void toggleMaterial(int materialId) {
    final next = {...state.selectedMaterialIds};
    if (!next.remove(materialId)) next.add(materialId);
    emit(state.copyWith(selectedMaterialIds: next));
  }

  /// Reloads only the materials list (retry after a materials load failure).
  Future<void> retryMaterials() async {
    emit(state.copyWith(materialsStatus: MaterialsStatus.loading));
    final result = await _getMaterials(subjectId);
    if (isClosed) return;
    result.fold(
      (_) => emit(state.copyWith(materialsStatus: MaterialsStatus.error)),
      (materials) => emit(state.copyWith(
        materialsStatus: MaterialsStatus.loaded,
        materials: materials,
      )),
    );
  }

  /// Completes the session with [note] and the current statuses/materials.
  /// Returns `true` on success; on failure it keeps the sheet open with
  /// [EditSessionState.submitError].
  Future<bool> submit(String note) async {
    final data = state.data;
    if (data == null || state.isSubmitting) return false;

    emit(state.copyWith(isSubmitting: true, submitError: () => null));

    // The backend expects only the procedures whose status was actually
    // changed by the student.
    final performed = state.editedStatuses.entries
        .map<PerformedProcedure>(
          (e) => (plannedProcedureId: e.key, status: e.value.apiValue),
        )
        .toList();

    final result = await _completeSession(
      CompleteSessionParams(
        treatmentSessionId: treatmentSessionId,
        studentNotes: note.trim(),
        materialIds: state.selectedMaterialIds.toList(),
        performedProcedures: performed,
      ),
    );

    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(state.copyWith(
          isSubmitting: false,
          submitError: () => failure.message,
        ));
        return false;
      },
      (_) {
        emit(state.copyWith(isSubmitting: false));
        return true;
      },
    );
  }
}
