import 'package:academic_dental_clinic/core/usecases/use_cases.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/assigned_patient_entity.dart';
import '../repositories/patients_repository.dart';

class GetAssignedPatientsUseCase
    extends UseCaseNoParam<List<AssignedPatientEntity>> {
  GetAssignedPatientsUseCase(this.patientsRepo);

  final PatientsRepository patientsRepo;

  @override
  Future<Either<Failure, List<AssignedPatientEntity>>> call() {
    return patientsRepo.getAssignedPatients();
  }
}