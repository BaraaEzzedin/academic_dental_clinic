import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../repositories/treatment_sessions_repository.dart';

class EditTreatmentSessionUseCase extends UseCase<Unit, EditSessionParams> {
  EditTreatmentSessionUseCase(this.repository);

  final TreatmentSessionsRepository repository;

  @override
  Future<Either<Failure, Unit>> call(EditSessionParams params) {
    return repository.editSession(
      treatmentSessionId: params.treatmentSessionId,
      title: params.title,
      appointmentDate: params.appointmentDate,
      appointmentStart: params.appointmentStart,
    );
  }
}

class EditSessionParams extends Equatable {
  const EditSessionParams({
    required this.treatmentSessionId,
    this.title,
    this.appointmentDate,
    this.appointmentStart,
  });

  final int treatmentSessionId;

  /// Sent only when the title changed.
  final String? title;

  /// Sent together only when the date/time changed.
  final DateTime? appointmentDate;
  final String? appointmentStart;

  @override
  List<Object?> get props =>
      [treatmentSessionId, title, appointmentDate, appointmentStart];
}
