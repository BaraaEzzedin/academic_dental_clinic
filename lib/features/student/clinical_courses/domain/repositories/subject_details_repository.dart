import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/subject_details_entity.dart';

abstract class SubjectDetailsRepository {
  /// Fetches the progress details for the subject [subjectId].
  Future<Either<Failure, SubjectDetailsEntity>> getSubjectDetails(
    int subjectId,
  );
}
