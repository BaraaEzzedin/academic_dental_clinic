import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/staff_auth_repository.dart';
import '../data_source/auth_local_data_source.dart';
import '../data_source/staff_auth_remote_data_source.dart';

class StaffAuthRepositoryImpl implements StaffAuthRepository {
  const StaffAuthRepositoryImpl(this.remote, this.local);

  final StaffAuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remote.login(
        email: email,
        password: password,
      );
      await local.saveToken(result.accessToken);
      await local.saveUserName(result.user.fullName);
      await local.saveStudentProfile(
        studyYear: result.user.studyYear,
        academicYear: result.user.academicYear,
      );
      return Right(result.user);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    // Best-effort: tell the backend, but always clear the local session so the
    // user is signed out even if the network call fails.
    try {
      await remote.logout();
    } on AppException {
      // Ignore — proceed to clear the local session.
    }
    try {
      await local.clearToken();
    } on AppException {
      // Ignore — the token may already be gone.
    }
    return const Right(unit);
  }
}