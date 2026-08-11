import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/case_acceptance_request_entity.dart';
import '../entities/subject_config_entity.dart';

abstract class CaseAcceptanceRequestRepository {
  Future<Either<Failure, SubjectConfigEntity>> getSubjectConfiguration(
    int subjectId,
  );

  Future<Either<Failure, Unit>> submitAcceptanceRequest(
    CaseAcceptanceRequestEntity request,
  );
}