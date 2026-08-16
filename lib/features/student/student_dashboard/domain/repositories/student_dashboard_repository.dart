import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/student_dashboard_entity.dart';

abstract class StudentDashboardRepository {
  Future<Either<Failure, StudentDashboardEntity>> getDashboard();
}
