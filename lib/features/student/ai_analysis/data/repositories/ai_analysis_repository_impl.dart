import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failure_mapper.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/ai_analysis_result.dart';
import '../../domain/repositories/ai_analysis_repository.dart';
import '../data_source/ai_analysis_remote_data_source.dart';

class AiAnalysisRepositoryImpl implements AiAnalysisRepository {
  const AiAnalysisRepositoryImpl(this.remote);

  final AiAnalysisRemoteDataSource remote;

  @override
  Future<Either<Failure, AiAnalysisResult>> analyze(String imagePath) async {
    try {
      final result = await remote.analyze(imagePath);
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
