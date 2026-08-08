import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/available_appointments_entity.dart';
import '../repositories/appointment_repository.dart';

class GetAvailableAppointmentsUseCase extends UseCase<
    AvailableAppointmentsEntity, GetAvailableAppointmentsParams> {
  GetAvailableAppointmentsUseCase(this.repository);

  final AppointmentRepository repository;

  @override
  Future<Either<Failure, AvailableAppointmentsEntity>> call(
    GetAvailableAppointmentsParams params,
  ) {
    return repository.getAvailableAppointments(
      date: params.date,
      clinicalCaseId: params.clinicalCaseId,
    );
  }
}

class GetAvailableAppointmentsParams extends Equatable {
  const GetAvailableAppointmentsParams({
    required this.date,
    required this.clinicalCaseId,
  });

  final DateTime date;
  final int clinicalCaseId;

  @override
  List<Object?> get props => [date, clinicalCaseId];
}