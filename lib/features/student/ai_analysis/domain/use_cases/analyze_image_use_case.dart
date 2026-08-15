import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/use_cases.dart';
import '../entities/ai_analysis_result.dart';
import '../repositories/ai_analysis_repository.dart';

class AnalyzeImageUseCase implements UseCase<AiAnalysisResult, String> {
  const AnalyzeImageUseCase(this.repository);

  final AiAnalysisRepository repository;

  @override
  Future<Either<Failure, AiAnalysisResult>> call(String imagePath) {
    return repository.analyze(imagePath);
  }
}
