import 'package:equatable/equatable.dart';

import '../../../case_acceptance_request/domain/entities/procedure_request_entity.dart';
import 'patient_info_entity.dart';

/// The complete Add Patient (walk-in) request assembled across the 3 steps.
/// [imagePaths] are the local case-image files sent as the multipart `images`
/// parts; everything else is serialized into the multipart `data` JSON string.
class WalkInRequestEntity extends Equatable {
  const WalkInRequestEntity({
    required this.patientInfo,
    required this.subjectId,
    required this.plannedProcedures,
    required this.appointmentDate,
    required this.appointmentStart,
    this.imagePaths = const [],
  });

  final PatientInfoEntity patientInfo;
  final int subjectId;
  final List<ProcedureRequestEntity> plannedProcedures;

  /// ISO date (`yyyy-MM-dd`).
  final String appointmentDate;

  /// `HH:mm` start time.
  final String appointmentStart;

  final List<String> imagePaths;

  @override
  List<Object?> get props => [
        patientInfo,
        subjectId,
        plannedProcedures,
        appointmentDate,
        appointmentStart,
        imagePaths,
      ];
}
