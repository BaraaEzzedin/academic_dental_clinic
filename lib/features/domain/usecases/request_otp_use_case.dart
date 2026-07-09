import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../repositories/patient_auth_repository.dart';

class RequestOtp {
  const RequestOtp(this.patientAuthRepo);

  final PatientAuthRepository patientAuthRepo;

  Future<Either<Failure, Unit>> call({required String phone}) {
    return patientAuthRepo.requestOtp(phone: phone);
  }
}