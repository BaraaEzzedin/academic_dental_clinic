import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class DeviceTokenRepository {
  Future<Either<Failure, Unit>> registerToken(String token);
}