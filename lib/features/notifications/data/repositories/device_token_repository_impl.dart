import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/device_token_repository.dart';
import '../data_source/device_token_remote_data_source.dart';

class DeviceTokenRepositoryImpl implements DeviceTokenRepository {
  const DeviceTokenRepositoryImpl(this.remote);

  final DeviceTokenRemoteDataSource remote;

  @override
  Future<Either<Failure, Unit>> registerToken(String token) async {
    try {
      await remote.registerToken(token);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}