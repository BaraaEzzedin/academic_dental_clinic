import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/student_dashboard_entity.dart';
import '../repositories/student_dashboard_repository.dart';

class GetStudentDashboardUseCase
    extends UseCaseNoParam<StudentDashboardEntity> {
  GetStudentDashboardUseCase(this.repository);

  final StudentDashboardRepository repository;

  @override
  Future<Either<Failure, StudentDashboardEntity>> call() {
    return repository.getDashboard();
  }
}
