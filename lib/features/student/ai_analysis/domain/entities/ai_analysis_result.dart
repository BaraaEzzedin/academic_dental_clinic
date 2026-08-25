import 'package:equatable/equatable.dart';

import 'ai_finding.dart';

class AiAnalysisResult extends Equatable {
  const AiAnalysisResult({
    required this.findings,
    required this.imageUrl,
  });

  final List<AiFinding> findings;

  /// The processed/annotated image returned by the AI service.
  final String imageUrl;

  @override
  List<Object?> get props => [findings, imageUrl];
}