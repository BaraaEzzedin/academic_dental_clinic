import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../repositories/assigned_patients_repository.dart';

class CancelAssignedCaseUseCase extends UseCase<Unit, int> {
  CancelAssignedCaseUseCase(this.repository);

  final AssignedPatientsRepository repository;

  @override
  Future<Either<Failure, Unit>> call(int caseId) {
    return repository.cancelAssignedCase(caseId);
  }
}
