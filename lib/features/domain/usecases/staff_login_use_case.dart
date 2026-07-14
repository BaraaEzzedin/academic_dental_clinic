import 'package:academic_dental_clinic/core/usecases/use_cases.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/staff_auth_repository.dart';

class StaffLoginUseCase extends UseCase< User, LoginParams> {
   StaffLoginUseCase(this.staffAuthRepo);

  final StaffAuthRepository staffAuthRepo;

  @override
  Future<Either<Failure, User>> call( LoginParams params) {
    return staffAuthRepo.login(
      email: params.email,
      password: params.password,
    );
  }
}


class LoginParams {
  const LoginParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}