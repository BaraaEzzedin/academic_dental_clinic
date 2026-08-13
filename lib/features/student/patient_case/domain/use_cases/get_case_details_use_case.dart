import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/case_details_entity.dart';
import '../repositories/case_details_repository.dart';

class GetCaseDetailsUseCase extends UseCase<CaseDetailsEntity, int> {
  GetCaseDetailsUseCase(this.repository);

  final CaseDetailsRepository repository;

  @override
  Future<Either<Failure, CaseDetailsEntity>> call(int caseId) {
    return repository.getCaseDetails(caseId);
  }
}
