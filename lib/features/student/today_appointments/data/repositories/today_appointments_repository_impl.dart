import 'package:dartz/dartz.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/today_appointment_entity.dart';
import '../../domain/repositories/today_appointments_repository.dart';
import '../data_source/today_appointments_remote_data_source.dart';

class TodayAppointmentsRepositoryImpl implements TodayAppointmentsRepository {
  const TodayAppointmentsRepositoryImpl(this.remote);

  final TodayAppointmentsRemoteDataSource remote;

  @override
  Future<Either<Failure, List<TodayAppointmentEntity>>>
      getTodayAppointments() async {
    try {
      final result = await remote.getTodayAppointments();
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}