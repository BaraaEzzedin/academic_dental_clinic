import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/use_cases.dart';
import '../repositories/device_token_repository.dart';

class RegisterDeviceTokenUseCase implements UseCase<Unit, String> {
  const RegisterDeviceTokenUseCase(this.repository);

  final DeviceTokenRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String token) {
    return repository.registerToken(token);
  }
}