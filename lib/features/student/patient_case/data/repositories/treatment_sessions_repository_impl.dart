import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/treatment_session_entity.dart';
import '../../domain/repositories/treatment_sessions_repository.dart';
import '../data_source/treatment_sessions_remote_data_source.dart';

class TreatmentSessionsRepositoryImpl implements TreatmentSessionsRepository {
  const TreatmentSessionsRepositoryImpl(this.remote);

  final TreatmentSessionsRemoteDataSource remote;

  @override
  Future<Either<Failure, List<TreatmentSessionEntity>>> getTreatmentSessions(
    int clinicalCaseId,
  ) async {
    try {
      final result = await remote.getTreatmentSessions(clinicalCaseId);
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> createTreatmentSession({
    required int clinicalCaseId,
    required String title,
    DateTime? appointmentDate,
    String? appointmentStart,
  }) async {
    try {
      await remote.createTreatmentSession(
        clinicalCaseId: clinicalCaseId,
        title: title,
        appointmentDate: appointmentDate,
        appointmentStart: appointmentStart,
      );
      return const Right(unit);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}