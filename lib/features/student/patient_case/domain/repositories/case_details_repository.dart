import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/case_details_entity.dart';

abstract class CaseDetailsRepository {
  Future<Either<Failure, CaseDetailsEntity>> getCaseDetails(int caseId);
}
