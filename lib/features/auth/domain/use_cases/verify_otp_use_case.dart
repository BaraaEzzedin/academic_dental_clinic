import 'package:academic_dental_clinic/core/usecases/use_cases.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/patient_auth_repository.dart';

class VerifyOtpUseCase extends UseCase<User , VerifyOtpParams> {
  VerifyOtpUseCase(this.patientAuthRepo);

  final PatientAuthRepository patientAuthRepo;

  @override
  Future<Either<Failure, User>> call(VerifyOtpParams params) {
    return patientAuthRepo.verifyOtp(phone: params.phone, code: params.code);
  }
}

class VerifyOtpParams {
  const VerifyOtpParams({
    required this.phone,
    required this.code,
  });

  final String phone;
  final String code;
}