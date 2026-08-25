import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/session_summary_entity.dart';
import '../repositories/treatment_sessions_repository.dart';

class GetSessionSummaryUseCase extends UseCase<SessionSummaryEntity, int> {
  GetSessionSummaryUseCase(this.repository);

  final TreatmentSessionsRepository repository;

  @override
  Future<Either<Failure, SessionSummaryEntity>> call(int sessionId) =>
      repository.getSessionSummary(sessionId);
}
