import 'package:equatable/equatable.dart';
import 'procedure_request_entity.dart';

class CaseAcceptanceRequestEntity extends Equatable {
  const CaseAcceptanceRequestEntity({
    required this.patientId,
    required this.subjectId,
    required this.procedureRequests,
    this.media = const [],
  });

  final int patientId;
  final int subjectId;
  final List<ProcedureRequestEntity> procedureRequests;

  /// Media belongs to the whole request (not to individual procedures).
  final List<String> media;

  @override
  List<Object?> get props => [
        patientId,
        subjectId,
        procedureRequests,
        media,
      ];
}