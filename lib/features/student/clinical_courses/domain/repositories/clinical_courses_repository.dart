import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/clinical_course_entity.dart';

abstract class ClinicalCoursesRepository {
  Future<Either<Failure, List<ClinicalCourseEntity>>> getClinicalCourses();
}