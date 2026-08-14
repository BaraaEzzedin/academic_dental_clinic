import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/treatment_session_entity.dart';

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
}