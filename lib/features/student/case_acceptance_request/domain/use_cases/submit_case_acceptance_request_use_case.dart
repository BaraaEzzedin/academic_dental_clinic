import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/case_acceptance_request_entity.dart';
import '../repositories/case_acceptance_request_repository.dart';

class SubmitCaseAcceptanceRequestUseCase
    extends UseCase<Unit, CaseAcceptanceRequestEntity> {
  SubmitCaseAcceptanceRequestUseCase(this._repository);

  final CaseAcceptanceRequestRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(CaseAcceptanceRequestEntity request) {
    return _repository.submitAcceptanceRequest(request);
  }
}