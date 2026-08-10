import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/assigned_patient_details_entity.dart';
import '../repositories/assigned_patients_repository.dart';

class GetAssignedCaseDetailsUseCase
    extends UseCase<AssignedPatientDetailsEntity, int> {
  GetAssignedCaseDetailsUseCase(this.repository);

  final AssignedPatientsRepository repository;

  @override
  Future<Either<Failure, AssignedPatientDetailsEntity>> call(int caseId) {
    return repository.getAssignedPatientDetails(caseId);
  }
}