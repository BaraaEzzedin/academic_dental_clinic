import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../repositories/treatment_sessions_repository.dart';

class StartTreatmentSessionUseCase extends UseCase<Unit, int> {
  StartTreatmentSessionUseCase(this.repository);

  final TreatmentSessionsRepository repository;

  @override
  Future<Either<Failure, Unit>> call(int treatmentSessionId) =>
      repository.startSession(treatmentSessionId);
}
