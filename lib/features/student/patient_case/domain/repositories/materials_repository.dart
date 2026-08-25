import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/material_entity.dart';

abstract class MaterialsRepository {
  /// Fetches the materials available for the subject [subjectId].
  Future<Either<Failure, List<MaterialEntity>>> getMaterials(int subjectId);
}
