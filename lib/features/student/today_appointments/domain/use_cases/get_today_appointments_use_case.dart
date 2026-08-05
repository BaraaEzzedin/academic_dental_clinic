import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/today_appointment_entity.dart';
import '../repositories/today_appointments_repository.dart';

class GetTodayAppointmentsUseCase
    extends UseCaseNoParam<List<TodayAppointmentEntity>> {
  GetTodayAppointmentsUseCase(this.repository);

  final TodayAppointmentsRepository repository;

  @override
  Future<Either<Failure, List<TodayAppointmentEntity>>> call() {
    return repository.getTodayAppointments();
  }
}