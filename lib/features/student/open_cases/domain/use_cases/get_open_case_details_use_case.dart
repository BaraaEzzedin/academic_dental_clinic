import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/open_case_details_entity.dart';
import '../repositories/open_cases_repository.dart';

class GetOpenCaseDetailsUseCase
    extends UseCase<OpenCaseDetailsEntity, int> {
  GetOpenCaseDetailsUseCase(this.repository);

  final OpenCasesRepository repository;

  @override
  Future<Either<Failure, OpenCaseDetailsEntity>> call(int id) {
    return repository.getOpenCaseDetails(id);
  }
}