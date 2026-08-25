import 'package:equatable/equatable.dart';
import 'procedure_request_entity.dart';

/// Payload submitted to the supervisor: the planned procedures for a case,
/// plus any attached case images (uploaded as multipart files at submit time).
class CaseAcceptanceRequestEntity extends Equatable {
  const CaseAcceptanceRequestEntity({
    required this.clinicalCaseId,
    required this.plannedProcedures,
    this.imagePaths = const [],
  });

  final int clinicalCaseId;
  final List<ProcedureRequestEntity> plannedProcedures;

  /// Local file paths of the selected case images.
  final List<String> imagePaths;

  @override
  List<Object?> get props => [clinicalCaseId, plannedProcedures, imagePaths];
}