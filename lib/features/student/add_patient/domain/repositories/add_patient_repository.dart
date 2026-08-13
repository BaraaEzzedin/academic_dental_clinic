import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/walk_in_request_entity.dart';

abstract class AddPatientRepository {
  /// Creates a walk-in clinical case, submitting the whole request plus its
  /// case images as `multipart/form-data`.
  Future<Either<Failure, Unit>> createWalkInCase(WalkInRequestEntity request);
}
