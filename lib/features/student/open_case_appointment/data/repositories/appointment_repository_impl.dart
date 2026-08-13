import 'package:dartz/dartz.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/available_appointments_entity.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../data_source/appointment_remote_data_source.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  const AppointmentRepositoryImpl(this.remote);

  final AppointmentRemoteDataSource remote;

  @override
  Future<Either<Failure, AvailableAppointmentsEntity>> getAvailableAppointments({
    required DateTime date,
    required int subjectId,
  }) async {
    try {
      final result = await remote.getAvailableAppointments(
        date: date,
        subjectId: subjectId,
      );
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> bookAppointment({
    required int clinicalCaseId,
    required DateTime date,
    required String time,
  }) async {
    try {
      await remote.bookAppointment(
        clinicalCaseId: clinicalCaseId,
        date: date,
        time: time,
      );
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}