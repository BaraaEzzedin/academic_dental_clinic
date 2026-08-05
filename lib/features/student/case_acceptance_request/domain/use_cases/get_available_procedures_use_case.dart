import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/available_procedure_entity.dart';
import '../repositories/case_acceptance_request_repository.dart';

class GetAvailableProceduresUseCase
    extends UseCase<List<AvailableProcedureEntity>, int> {
  GetAvailableProceduresUseCase(this._repository);

  final CaseAcceptanceRequestRepository _repository;

  @override
  Future<Either<Failure, List<AvailableProcedureEntity>>> call(int subjectId) {
    return _repository.getAvailableProcedures(subjectId);
  }
}