import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/use_cases.dart';
import '../repositories/staff_auth_repository.dart';

class LogoutUseCase extends UseCaseNoParam<Unit> {
  LogoutUseCase(this.repository);

  final StaffAuthRepository repository;

  @override
  Future<Either<Failure, Unit>> call() => repository.logout();
}
