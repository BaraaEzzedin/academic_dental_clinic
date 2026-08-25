import 'package:academic_dental_clinic/core/usecases/use_cases.dart';
import 'package:academic_dental_clinic/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/patient_auth_repository.dart';

class RequestOtpUseCase extends UseCase<Unit , RequestOtpParams > {
   RequestOtpUseCase(this.patientAuthRepo);

  final PatientAuthRepository patientAuthRepo;

  @override
  Future<Either<Failure, Unit>> call(RequestOtpParams params) {
    return patientAuthRepo.requestOtp(phone: params.phone);
  }
}

class RequestOtpParams {
  const RequestOtpParams({required this.phone});

  final String phone;
}
