import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/clinical_course_entity.dart';
import '../repositories/clinical_courses_repository.dart';

class GetClinicalCoursesUseCase
    extends UseCaseNoParam<List<ClinicalCourseEntity>> {
  GetClinicalCoursesUseCase(this.repository);

  final ClinicalCoursesRepository repository;

  @override
  Future<Either<Failure, List<ClinicalCourseEntity>>> call() {
    return repository.getClinicalCourses();
  }
}