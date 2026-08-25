import 'package:equatable/equatable.dart';

import '../../../domain/entities/ai_analysis_result.dart';

/// Drives the AI analysis screen. The selected image path is kept across every
/// status so the preview stays visible while analyzing, on success, and on error.
enum AiAnalysisStatus { idle, analyzing, success, failure }

class AiAnalysisState extends Equatable {
  const AiAnalysisState({
    this.imagePath,
    this.status = AiAnalysisStatus.idle,
    this.result,
    this.errorMessage,
  });

  final String? imagePath;
  final AiAnalysisStatus status;
  final AiAnalysisResult? result;
  final String? errorMessage;

  bool get hasImage => imagePath != null;
  bool get isAnalyzing => status == AiAnalysisStatus.analyzing;
  bool get isSuccess => status == AiAnalysisStatus.success;
  bool get isFailure => status == AiAnalysisStatus.failure;

  /// Analysis is allowed with a picked image and no in-flight request.
  bool get canAnalyze => hasImage && !isAnalyzing;

  AiAnalysisState copyWith({
    String? imagePath,
    bool clearImage = false,
    AiAnalysisStatus? status,
    AiAnalysisResult? result,
    bool clearResult = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AiAnalysisState(
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      status: status ?? this.status,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [imagePath, status, result, errorMessage];
}
