import 'package:dartz/dartz.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/student_dashboard_entity.dart';
import '../../domain/repositories/student_dashboard_repository.dart';
import '../data_source/student_dashboard_remote_data_source.dart';

class StudentDashboardRepositoryImpl implements StudentDashboardRepository {
  const StudentDashboardRepositoryImpl(this.remote);

  final StudentDashboardRemoteDataSource remote;

  @override
  Future<Either<Failure, StudentDashboardEntity>> getDashboard() async {
    try {
      final result = await remote.getDashboard();
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
