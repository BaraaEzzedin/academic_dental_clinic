import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/assigned_patient_entity.dart';

abstract class PatientsRepository {
  Future<Either<Failure, List<AssignedPatientEntity>>> getAssignedPatients();
}