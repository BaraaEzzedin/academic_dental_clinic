import 'package:dartz/dartz.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failure_mapper.dart';
import '../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/staff_auth_repository.dart';
import '../datasources/auth/auth_local_data_source.dart';
import '../datasources/auth/staff_auth_remote_data_source.dart';

class StaffAuthRepositoryImpl implements StaffAuthRepository {
  const StaffAuthRepositoryImpl(this.remote, this.local);

  final StaffAuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  @override
  Future<Either<Failure, User>> login({
    required String universityId,
    required String password,
  }) async {
    try {
      final result = await remote.login(
        universityId: universityId,
        password: password,
      );
      await local.saveToken(result.accessToken);
      return Right(result.user);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}