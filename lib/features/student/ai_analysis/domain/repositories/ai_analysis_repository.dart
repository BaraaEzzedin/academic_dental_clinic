import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/ai_analysis_result.dart';

abstract class AiAnalysisRepository {
  Future<Either<Failure, AiAnalysisResult>> analyze(String imagePath);
}
