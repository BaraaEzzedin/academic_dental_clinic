import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/session_procedures_entity.dart';
import '../repositories/treatment_sessions_repository.dart';

class GetPlannedProceduresUseCase
    extends UseCase<SessionProceduresEntity, int> {
  GetPlannedProceduresUseCase(this.repository);

  final TreatmentSessionsRepository repository;

  @override
  Future<Either<Failure, SessionProceduresEntity>> call(
    int treatmentSessionId,
  ) =>
      repository.getPlannedProcedures(treatmentSessionId);
}
