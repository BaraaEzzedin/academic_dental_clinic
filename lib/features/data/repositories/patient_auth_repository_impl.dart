import 'package:dartz/dartz.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failure_mapper.dart';
import '../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/patient_auth_repository.dart';
import '../datasources/auth/auth_local_data_source.dart';
import '../datasources/auth/patient_auth_remote_data_source.dart';

class PatientAuthRepositoryImpl implements PatientAuthRepository {
  const PatientAuthRepositoryImpl(this.remote, this.local);

  final PatientAuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  @override
  Future<Either<Failure, Unit>> requestOtp({
    required String phone,
  }) async {
    try {
      await remote.requestOtp(phone: phone);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await remote.verifyOtp(phone: phone, code: code);
      await local.saveToken(response.accessToken);
      return Right(response.user);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}