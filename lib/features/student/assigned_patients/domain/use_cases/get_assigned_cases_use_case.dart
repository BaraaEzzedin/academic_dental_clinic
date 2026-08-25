import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/assigned_patient_entity.dart';
import '../repositories/assigned_patients_repository.dart';

class GetAssignedCasesUseCase
    extends UseCaseNoParam<List<AssignedPatientEntity>> {
  GetAssignedCasesUseCase(this.repository);

  final AssignedPatientsRepository repository;

  @override
  Future<Either<Failure, List<AssignedPatientEntity>>> call() {
    return repository.getAssignedPatients();
  }
}