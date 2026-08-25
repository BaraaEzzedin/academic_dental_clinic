import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/student_schedule_entity.dart';
import '../repositories/today_appointments_repository.dart';

class GetTodayAppointmentsUseCase
    extends UseCaseNoParam<StudentScheduleEntity> {
  GetTodayAppointmentsUseCase(this.repository);

  final TodayAppointmentsRepository repository;

  @override
  Future<Either<Failure, StudentScheduleEntity>> call() {
    return repository.getStudentSchedule();
  }
}