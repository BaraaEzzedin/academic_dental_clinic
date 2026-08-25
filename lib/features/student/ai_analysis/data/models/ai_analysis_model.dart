import '../../domain/entities/ai_analysis_result.dart';
import 'ai_finding_model.dart';

class AiAnalysisModel extends AiAnalysisResult {
  const AiAnalysisModel({
    required super.findings,
    required super.imageUrl,
  });

  factory AiAnalysisModel.fromJson(Map<String, dynamic> json) {
    final findings = (json['findings'] as List<dynamic>? ?? const [])
        .map((e) => AiFindingModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return AiAnalysisModel(
      findings: findings,
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }
}
