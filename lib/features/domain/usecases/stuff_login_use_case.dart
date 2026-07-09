import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/staff_auth_repository.dart';

class StuffLoginUseCase {
  const StuffLoginUseCase(this.stuffAuthRepo);

  final StaffAuthRepository stuffAuthRepo;

  Future<Either<Failure, User>> call({
    required String universityId,
    required String password,
  }) {
    return stuffAuthRepo.login(
      universityId: universityId,
      password: password,
    );
  }
}