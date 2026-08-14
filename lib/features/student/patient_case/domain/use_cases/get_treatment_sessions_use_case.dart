import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/treatment_session_entity.dart';
import '../repositories/treatment_sessions_repository.dart';

class GetTreatmentSessionsUseCase
    extends UseCase<List<TreatmentSessionEntity>, int> {
  GetTreatmentSessionsUseCase(this.repository);

  final TreatmentSessionsRepository repository;

  @override
  Future<Either<Failure, List<TreatmentSessionEntity>>> call(
    int clinicalCaseId,
  ) {
    return repository.getTreatmentSessions(clinicalCaseId);
  }
}