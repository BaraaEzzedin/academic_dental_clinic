import 'package:dartz/dartz.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/open_case_entity.dart';
import '../../domain/repositories/open_cases_repository.dart';
import '../data_source/open_cases_remote_data_source.dart';

class OpenCasesRepositoryImpl implements OpenCasesRepository {
  const OpenCasesRepositoryImpl(this.remote);

  final OpenCasesRemoteDataSource remote;

  @override
  Future<Either<Failure, List<OpenCaseEntity>>> getOpenCases() async {
    try {
      final result = await remote.getOpenCases();
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}