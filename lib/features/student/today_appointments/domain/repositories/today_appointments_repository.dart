import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/student_schedule_entity.dart';

abstract class TodayAppointmentsRepository {
  Future<Either<Failure, StudentScheduleEntity>> getStudentSchedule();
}