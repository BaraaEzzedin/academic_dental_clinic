import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/material_entity.dart';
import '../repositories/materials_repository.dart';

class GetMaterialsUseCase extends UseCase<List<MaterialEntity>, int> {
  GetMaterialsUseCase(this.repository);

  final MaterialsRepository repository;

  @override
  Future<Either<Failure, List<MaterialEntity>>> call(int subjectId) =>
      repository.getMaterials(subjectId);
}
