import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/case_details_entity.dart';
import '../entities/case_media_upload.dart';

abstract class CaseDetailsRepository {
  Future<Either<Failure, CaseDetailsEntity>> getCaseDetails(int caseId);

  /// Uploads one or more media items to the case [caseId] as
  /// `multipart/form-data`. Currently the caller passes a single item, but
  /// the list keeps the contract ready for batch uploads.
  Future<Either<Failure, Unit>> uploadCaseMedia({
    required int caseId,
    required List<CaseMediaUpload> items,
  });
}
