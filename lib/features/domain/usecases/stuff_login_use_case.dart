import 'package:academic_dental_clinic/core/usecases/use_cases.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/staff_auth_repository.dart';

class StuffLoginUseCase extends UseCase< User, LoginParams> {
   StuffLoginUseCase(this.stuffAuthRepo);

  final StaffAuthRepository stuffAuthRepo;

  @override
  Future<Either<Failure, User>> call( LoginParams params) {
    return stuffAuthRepo.login(
      universityId: params.universityId,
      password: params.password,
    );
  }
}


class LoginParams {
  const LoginParams({
    required this.universityId,
    required this.password,
  });

  final String universityId;
  final String password;
}