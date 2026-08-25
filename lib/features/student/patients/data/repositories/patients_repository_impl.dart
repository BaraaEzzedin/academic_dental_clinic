import 'package:dartz/dartz.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/assigned_patient_entity.dart';
import '../../domain/repositories/patients_repository.dart';
import '../data_source/patients_remote_data_source.dart';

class PatientsRepositoryImpl implements PatientsRepository {
  const PatientsRepositoryImpl(this.remote);

  final PatientsRemoteDataSource remote;

  @override
  Future<Either<Failure, List<MyPatientEntity>>>
      getAssignedPatients() async {
    try {
      final result = await remote.getMyPatients();
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}