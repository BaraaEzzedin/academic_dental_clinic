import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/case_details_entity.dart';
import '../../domain/entities/case_media_upload.dart';
import '../../domain/repositories/case_details_repository.dart';
import '../data_source/case_details_remote_data_source.dart';

class CaseDetailsRepositoryImpl implements CaseDetailsRepository {
  const CaseDetailsRepositoryImpl(this.remote);

  final CaseDetailsRemoteDataSource remote;

  @override
  Future<Either<Failure, CaseDetailsEntity>> getCaseDetails(int caseId) async {
    try {
      final result = await remote.getCaseDetails(caseId);
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> uploadCaseMedia({
    required int caseId,
    required List<CaseMediaUpload> items,
  }) async {
    try {
      await remote.uploadCaseMedia(caseId: caseId, items: items);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
