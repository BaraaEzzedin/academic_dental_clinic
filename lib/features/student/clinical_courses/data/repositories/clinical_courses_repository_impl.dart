import 'package:dartz/dartz.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/clinical_course_entity.dart';
import '../../domain/repositories/clinical_courses_repository.dart';
import '../data_source/clinical_courses_remote_data_source.dart';

class ClinicalCoursesRepositoryImpl implements ClinicalCoursesRepository {
  const ClinicalCoursesRepositoryImpl(this.remote);

  final ClinicalCoursesRemoteDataSource remote;

  @override
  Future<Either<Failure, List<ClinicalCourseEntity>>>
      getClinicalCourses() async {
    try {
      final result = await remote.getClinicalCourses();
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}