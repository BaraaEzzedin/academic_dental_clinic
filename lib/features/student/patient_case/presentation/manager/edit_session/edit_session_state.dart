import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/material_entity.dart';
import '../../../domain/entities/session_procedure_entity.dart';
import '../../../domain/entities/session_procedures_entity.dart';
import '../../models/session_procedure_status.dart';

enum EditSessionStatus { initial, loading, loaded, error }

enum MaterialsStatus { initial, loading, loaded, error }

class EditSessionState extends Equatable {
  const EditSessionState({
    this.status = EditSessionStatus.initial,
    this.data,
    this.editedStatuses = const {},
    this.materialsStatus = MaterialsStatus.initial,
    this.materials = const [],
    this.selectedMaterialIds = const {},
    this.isSubmitting = false,
    this.submitError,
    this.errorMessage,
  });

  final EditSessionStatus status;
  final SessionProceduresEntity? data;

  /// Local status overrides keyed by procedure id (editable items only).
  final Map<int, SessionProcedureStatus> editedStatuses;

  final MaterialsStatus materialsStatus;
  final List<MaterialEntity> materials;
  final Set<int> selectedMaterialIds;

  final bool isSubmitting;
  final String? submitError;
  final String? errorMessage;

  bool get isLoading =>
      status == EditSessionStatus.initial ||
      status == EditSessionStatus.loading;

  bool get hasError => status == EditSessionStatus.error;

  bool get isLoadingMaterials =>
      materialsStatus == MaterialsStatus.initial ||
      materialsStatus == MaterialsStatus.loading;

  bool get hasMaterialsError => materialsStatus == MaterialsStatus.error;

  List<SessionProcedureEntity> get _procedures => data?.procedures ?? const [];

  /// Already-completed procedures — shown read-only.
  List<SessionProcedureEntity> get completedProcedures => _procedures
      .where((p) =>
          sessionProcedureStatusFromApi(p.rawStatus) ==
          SessionProcedureStatus.completed)
      .toList();

  /// Procedures the student can still update.
  List<SessionProcedureEntity> get editableProcedures => _procedures
      .where((p) =>
          sessionProcedureStatusFromApi(p.rawStatus) !=
          SessionProcedureStatus.completed)
      .toList();

  /// The current (possibly edited) status for [procedure].
  SessionProcedureStatus statusFor(SessionProcedureEntity procedure) =>
      editedStatuses[procedure.id] ??
      sessionProcedureStatusFromApi(procedure.rawStatus);

  EditSessionState copyWith({
    EditSessionStatus? status,
    SessionProceduresEntity? data,
    Map<int, SessionProcedureStatus>? editedStatuses,
    MaterialsStatus? materialsStatus,
    List<MaterialEntity>? materials,
    Set<int>? selectedMaterialIds,
    bool? isSubmitting,
    ValueGetter<String?>? submitError,
    String? errorMessage,
  }) {
    return EditSessionState(
      status: status ?? this.status,
      data: data ?? this.data,
      editedStatuses: editedStatuses ?? this.editedStatuses,
      materialsStatus: materialsStatus ?? this.materialsStatus,
      materials: materials ?? this.materials,
      selectedMaterialIds: selectedMaterialIds ?? this.selectedMaterialIds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: submitError != null ? submitError() : this.submitError,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        data,
        editedStatuses,
        materialsStatus,
        materials,
        selectedMaterialIds,
        isSubmitting,
        submitError,
        errorMessage,
      ];
}
