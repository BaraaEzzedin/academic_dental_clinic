import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/use_cases/analyze_image_use_case.dart';
import 'ai_analysis_state.dart';

/// Drives the AI analysis flow: image selection, then the analyze request.
/// The image is never cleared automatically, so the preview stays visible
/// through the analyzing, success, and error states.
class AiAnalysisCubit extends Cubit<AiAnalysisState> {
  AiAnalysisCubit({
    required AnalyzeImageUseCase analyzeImage,
    ImagePicker? imagePicker,
  })  : _analyzeImage = analyzeImage,
        _imagePicker = imagePicker ?? ImagePicker(),
        super(const AiAnalysisState());

  final AnalyzeImageUseCase _analyzeImage;
  final ImagePicker _imagePicker;

  /// Picks a single image from [source] (camera or gallery). Selecting a new
  /// image resets any previous result/error so the screen returns to idle.
  Future<void> pickImage(ImageSource source) async {
    final file = await _imagePicker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 2000,
    );
    if (file == null) return;
    emit(
      state.copyWith(
        imagePath: file.path,
        status: AiAnalysisStatus.idle,
        clearResult: true,
        clearError: true,
      ),
    );
  }

  Future<void> analyze() async {
    if (!state.canAnalyze) return;
    emit(state.copyWith(status: AiAnalysisStatus.analyzing, clearError: true));

    final result = await _analyzeImage(state.imagePath!);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AiAnalysisStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (analysis) => emit(
        state.copyWith(
          status: AiAnalysisStatus.success,
          result: analysis,
        ),
      ),
    );
  }
}
