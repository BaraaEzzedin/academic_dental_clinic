import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../repositories/treatment_sessions_repository.dart';

class CreateTreatmentSessionUseCase
    extends UseCase<Unit, CreateTreatmentSessionParams> {
  CreateTreatmentSessionUseCase(this.repository);

  final TreatmentSessionsRepository repository;

  @override
  Future<Either<Failure, Unit>> call(CreateTreatmentSessionParams params) {
    return repository.createTreatmentSession(
      clinicalCaseId: params.clinicalCaseId,
      title: params.title,
      appointmentDate: params.appointmentDate,
      appointmentStart: params.appointmentStart,
    );
  }
}

class CreateTreatmentSessionParams extends Equatable {
  const CreateTreatmentSessionParams({
    required this.clinicalCaseId,
    required this.title,
    this.appointmentDate,
    this.appointmentStart,
  });

  final int clinicalCaseId;
  final String title;

  /// Null for the first session (no appointment scheduled yet).
  final DateTime? appointmentDate;
  final String? appointmentStart;

  @override
  List<Object?> get props =>
      [clinicalCaseId, title, appointmentDate, appointmentStart];
}