import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/walk_in_request_entity.dart';
import '../repositories/add_patient_repository.dart';

class CreateWalkInCaseUseCase extends UseCase<Unit, WalkInRequestEntity> {
  CreateWalkInCaseUseCase(this.repository);

  final AddPatientRepository repository;

  @override
  Future<Either<Failure, Unit>> call(WalkInRequestEntity request) {
    return repository.createWalkInCase(request);
  }
}
