import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/assigned_patient_details_entity.dart';
import '../entities/assigned_patient_entity.dart';

abstract class AssignedPatientsRepository {
  Future<Either<Failure, List<AssignedPatientEntity>>> getAssignedPatients();
  Future<Either<Failure, AssignedPatientDetailsEntity>> getAssignedPatientDetails(
    int caseId,
  );
}