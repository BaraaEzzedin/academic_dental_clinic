import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../repositories/appointment_repository.dart';

/// Books a clinical appointment for an open case on the selected day/time.
class BookAppointmentUseCase extends UseCase<Unit, BookAppointmentParams> {
  BookAppointmentUseCase(this.repository);

  final AppointmentRepository repository;

  @override
  Future<Either<Failure, Unit>> call(BookAppointmentParams params) {
    return repository.bookAppointment(
      clinicalCaseId: params.clinicalCaseId,
      date: params.date,
      time: params.time,
    );
  }
}

class BookAppointmentParams extends Equatable {
  const BookAppointmentParams({
    required this.clinicalCaseId,
    required this.date,
    required this.time,
  });

  final int clinicalCaseId;
  final DateTime date;
  final String time;

  @override
  List<Object?> get props => [clinicalCaseId, date, time];
}