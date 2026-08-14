import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../repositories/treatment_sessions_repository.dart';

class CompleteTreatmentSessionUseCase
    extends UseCase<Unit, CompleteSessionParams> {
  CompleteTreatmentSessionUseCase(this.repository);

  final TreatmentSessionsRepository repository;

  @override
  Future<Either<Failure, Unit>> call(CompleteSessionParams params) {
    return repository.completeSession(
      treatmentSessionId: params.treatmentSessionId,
      studentNotes: params.studentNotes,
      materialIds: params.materialIds,
      performedProcedures: params.performedProcedures,
    );
  }
}

class CompleteSessionParams extends Equatable {
  const CompleteSessionParams({
    required this.treatmentSessionId,
    required this.studentNotes,
    required this.materialIds,
    required this.performedProcedures,
  });

  final int treatmentSessionId;
  final String studentNotes;
  final List<int> materialIds;
  final List<PerformedProcedure> performedProcedures;

  @override
  List<Object?> get props =>
      [treatmentSessionId, studentNotes, materialIds, performedProcedures];
}
