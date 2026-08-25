import 'package:dartz/dartz.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/subject_details_entity.dart';
import '../../domain/repositories/subject_details_repository.dart';
import '../data_source/subject_details_remote_data_source.dart';

class SubjectDetailsRepositoryImpl implements SubjectDetailsRepository {
  const SubjectDetailsRepositoryImpl(this.remote);

  final SubjectDetailsRemoteDataSource remote;

  @override
  Future<Either<Failure, SubjectDetailsEntity>> getSubjectDetails(
    int subjectId,
  ) async {
    try {
      final result = await remote.getSubjectDetails(subjectId);
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
