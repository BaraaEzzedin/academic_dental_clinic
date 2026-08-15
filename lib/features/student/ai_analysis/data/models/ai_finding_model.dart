import '../../domain/entities/ai_finding.dart';

class AiFindingModel extends AiFinding {
  const AiFindingModel({
    required super.condition,
    required super.confidence,
    required super.region,
    required super.color,
  });

  factory AiFindingModel.fromJson(Map<String, dynamic> json) {
    return AiFindingModel(
      condition: json['condition'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      region: json['region'] as String? ?? '',
      color: json['color'] as String? ?? '',
    );
  }
}
