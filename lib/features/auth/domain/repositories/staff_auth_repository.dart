import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class StaffAuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Signs out: calls the backend (best-effort) and clears the local session.
  Future<Either<Failure, Unit>> logout();
}