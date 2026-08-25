import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/session_procedures_entity.dart';
import '../entities/session_summary_entity.dart';
import '../entities/treatment_session_entity.dart';

/// One performed procedure sent in the complete-session request body.
typedef PerformedProcedure = ({int plannedProcedureId, String status});

abstract class TreatmentSessionsRepository {
  /// Fetches the treatment sessions for the clinical case [clinicalCaseId].
  Future<Either<Failure, List<TreatmentSessionEntity>>> getTreatmentSessions(
    int clinicalCaseId,
  );

  /// Creates a treatment session for the clinical case [clinicalCaseId].
  ///
  /// The first session has no appointment yet, so [appointmentDate] and
  /// [appointmentStart] may be null.
  Future<Either<Failure, Unit>> createTreatmentSession({
    required int clinicalCaseId,
    required String title,
    DateTime? appointmentDate,
    String? appointmentStart,
  });

  /// Fetches the planned procedures + progress for [treatmentSessionId].
  Future<Either<Failure, SessionProceduresEntity>> getPlannedProcedures(
    int treatmentSessionId,
  );

  /// Fetches the summary of the completed session [sessionId].
  Future<Either<Failure, SessionSummaryEntity>> getSessionSummary(
    int sessionId,
  );

  /// Starts the upcoming session [treatmentSessionId].
  Future<Either<Failure, Unit>> startSession(int treatmentSessionId);

  /// Edits the upcoming session [treatmentSessionId]; only non-null fields sent.
  Future<Either<Failure, Unit>> editSession({
    required int treatmentSessionId,
    String? title,
    DateTime? appointmentDate,
    String? appointmentStart,
  });

  /// Completes the session with the student notes, selected [materialIds] and
  /// the [performedProcedures] statuses.
  Future<Either<Failure, Unit>> completeSession({
    required int treatmentSessionId,
    required String studentNotes,
    required List<int> materialIds,
    required List<PerformedProcedure> performedProcedures,
  });
}