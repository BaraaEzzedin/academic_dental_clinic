import 'package:academic_dental_clinic/core/usecases/use_cases.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/assigned_patient_entity.dart';
import '../repositories/patients_repository.dart';

class GetMyPatientsUseCase
    extends UseCaseNoParam<List<MyPatientEntity>> {
  GetMyPatientsUseCase(this.patientsRepo);

  final PatientsRepository patientsRepo;

  @override
  Future<Either<Failure, List<MyPatientEntity>>> call() {
    return patientsRepo.getAssignedPatients();
  }
}