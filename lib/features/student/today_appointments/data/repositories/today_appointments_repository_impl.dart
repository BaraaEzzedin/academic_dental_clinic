import 'package:dartz/dartz.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/student_schedule_entity.dart';
import '../../domain/repositories/today_appointments_repository.dart';
import '../data_source/today_appointments_remote_data_source.dart';

class TodayAppointmentsRepositoryImpl implements TodayAppointmentsRepository {
  const TodayAppointmentsRepositoryImpl(this.remote);

  final TodayAppointmentsRemoteDataSource remote;

  @override
  Future<Either<Failure, StudentScheduleEntity>> getStudentSchedule() async {
    try {
      final result = await remote.getStudentSchedule();
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}