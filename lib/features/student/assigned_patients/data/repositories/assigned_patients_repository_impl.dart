import 'package:dartz/dartz.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/assigned_patient_details_entity.dart';
import '../../domain/entities/assigned_patient_entity.dart';
import '../../domain/repositories/assigned_patients_repository.dart';
import '../data_source/assigned_patients_remote_data_source.dart';

class AssignedPatientsRepositoryImpl implements AssignedPatientsRepository {
  const AssignedPatientsRepositoryImpl(this.remote);

  final AssignedPatientsRemoteDataSource remote;

  @override
  Future<Either<Failure, List<AssignedPatientEntity>>>
      getAssignedPatients() async {
    try {
      final result = await remote.getAssignedPatients();
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AssignedPatientDetailsEntity>>
      getAssignedPatientDetails(int caseId) async {
    try {
      final result = await remote.getAssignedPatientDetails(caseId);
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelAssignedCase(int caseId) async {
    try {
      await remote.cancelAssignedCase(caseId);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}