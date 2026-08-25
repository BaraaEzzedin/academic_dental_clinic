import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/subject_config_entity.dart';
import '../repositories/case_acceptance_request_repository.dart';

class GetSubjectConfigurationUseCase
    extends UseCase<SubjectConfigEntity, int> {
  GetSubjectConfigurationUseCase(this._repository);

  final CaseAcceptanceRequestRepository _repository;

  @override
  Future<Either<Failure, SubjectConfigEntity>> call(int subjectId) {
    return _repository.getSubjectConfiguration(subjectId);
  }
}