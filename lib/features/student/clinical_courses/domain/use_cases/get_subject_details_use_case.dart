import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/subject_details_entity.dart';
import '../repositories/subject_details_repository.dart';

class GetSubjectDetailsUseCase extends UseCase<SubjectDetailsEntity, int> {
  GetSubjectDetailsUseCase(this.repository);

  final SubjectDetailsRepository repository;

  @override
  Future<Either<Failure, SubjectDetailsEntity>> call(int subjectId) {
    return repository.getSubjectDetails(subjectId);
  }
}
