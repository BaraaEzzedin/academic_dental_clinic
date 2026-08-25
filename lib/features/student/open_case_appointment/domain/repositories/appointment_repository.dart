import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/available_appointments_entity.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, AvailableAppointmentsEntity>> getAvailableAppointments({
    required DateTime date,
    required int subjectId,
  });

  Future<Either<Failure, Unit>> bookAppointment({
    required int clinicalCaseId,
    required DateTime date,
    required String time,
  });
}