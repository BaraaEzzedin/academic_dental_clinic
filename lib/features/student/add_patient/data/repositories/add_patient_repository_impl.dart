import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/walk_in_request_entity.dart';
import '../../domain/repositories/add_patient_repository.dart';
import '../data_source/add_patient_remote_data_source.dart';

class AddPatientRepositoryImpl implements AddPatientRepository {
  const AddPatientRepositoryImpl(this.remote);

  final AddPatientRemoteDataSource remote;

  @override
  Future<Either<Failure, Unit>> createWalkInCase(
    WalkInRequestEntity request,
  ) async {
    try {
      await remote.createWalkInCase(request);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
