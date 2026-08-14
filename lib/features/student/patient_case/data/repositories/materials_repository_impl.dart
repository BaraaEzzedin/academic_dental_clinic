import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/material_entity.dart';
import '../../domain/repositories/materials_repository.dart';
import '../data_source/materials_remote_data_source.dart';

class MaterialsRepositoryImpl implements MaterialsRepository {
  const MaterialsRepositoryImpl(this.remote);

  final MaterialsRemoteDataSource remote;

  @override
  Future<Either<Failure, List<MaterialEntity>>> getMaterials(
    int subjectId,
  ) async {
    try {
      final result = await remote.getMaterials(subjectId);
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
