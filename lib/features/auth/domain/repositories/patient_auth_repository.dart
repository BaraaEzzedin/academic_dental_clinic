import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class PatientAuthRepository {
  Future<Either<Failure, Unit>> requestOtp({
    required String phone,
  });

  Future<Either<Failure, User>> verifyOtp({
    required String phone,
    required String code,
  });
}