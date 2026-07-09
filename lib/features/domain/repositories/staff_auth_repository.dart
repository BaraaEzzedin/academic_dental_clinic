import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class StaffAuthRepository {
  Future<Either<Failure, User>> login({
    required String universityId,
    required String password,
  });
}