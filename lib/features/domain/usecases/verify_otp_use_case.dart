import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/patient_auth_repository.dart';

class VerifyOtpUseCse {
  const VerifyOtpUseCse(this.patientAuthRepo);

  final PatientAuthRepository patientAuthRepo;

  Future<Either<Failure, User>> call({
    required String phone,
    required String code,
  }) {
    return patientAuthRepo.verifyOtp(phone: phone, code: code);
  }
}