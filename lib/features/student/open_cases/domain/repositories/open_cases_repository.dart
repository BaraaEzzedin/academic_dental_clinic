import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/open_case_entity.dart';

abstract class OpenCasesRepository {
  Future<Either<Failure, List<OpenCaseEntity>>> getOpenCases();
}