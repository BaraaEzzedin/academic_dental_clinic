import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/today_appointment_entity.dart';

abstract class TodayAppointmentsRepository {
  Future<Either<Failure, List<TodayAppointmentEntity>>> getTodayAppointments();
}