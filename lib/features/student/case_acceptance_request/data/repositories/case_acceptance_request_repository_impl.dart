import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/case_acceptance_request_entity.dart';
import '../../domain/entities/subject_config_entity.dart';
import '../../domain/repositories/case_acceptance_request_repository.dart';
import '../data_source/case_acceptance_request_remote_data_source.dart';
import '../models/case_acceptance_request_model.dart';

class CaseAcceptanceRequestRepositoryImpl
    implements CaseAcceptanceRequestRepository {
  const CaseAcceptanceRequestRepositoryImpl(this.remote);

  final CaseAcceptanceRequestRemoteDataSource remote;

  @override
  Future<Either<Failure, SubjectConfigEntity>> getSubjectConfiguration(
    int subjectId,
  ) async {
    try {
      final result = await remote.getSubjectConfiguration(subjectId);
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitAcceptanceRequest(
    CaseAcceptanceRequestEntity request,
  ) async {
    try {
      await remote.submitAcceptanceRequest(
        CaseAcceptanceRequestModel.fromEntity(request),
      );
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}