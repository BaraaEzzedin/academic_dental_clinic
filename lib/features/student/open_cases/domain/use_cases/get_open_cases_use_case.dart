import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/open_case_entity.dart';
import '../repositories/open_cases_repository.dart';

class GetOpenCasesUseCase extends UseCaseNoParam<List<OpenCaseEntity>> {
  GetOpenCasesUseCase(this.repository);

  final OpenCasesRepository repository;

  @override
  Future<Either<Failure, List<OpenCaseEntity>>> call() {
    return repository.getOpenCases();
  }
}