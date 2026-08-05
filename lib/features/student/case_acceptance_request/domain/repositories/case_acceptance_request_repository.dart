import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/available_procedure_entity.dart';
import '../entities/case_acceptance_request_entity.dart';

abstract class CaseAcceptanceRequestRepository {
  Future<Either<Failure, List<AvailableProcedureEntity>>> getAvailableProcedures(
    int subjectId,
  );

  Future<Either<Failure, Unit>> submitAcceptanceRequest(
    CaseAcceptanceRequestEntity request,
  );
}