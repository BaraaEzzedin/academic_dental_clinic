import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/case_media_upload.dart';
import '../../../domain/use_cases/upload_case_media_use_case.dart';
import 'upload_media_state.dart';

/// Drives the "Add Media" bottom sheet: image selection, description input,
/// and the single-item multipart upload. Business logic is kept here so the
/// sheet widget stays presentational.
class UploadMediaCubit extends Cubit<UploadMediaState> {
  UploadMediaCubit({
    required UploadCaseMediaUseCase uploadCaseMedia,
    required int caseId,
    ImagePicker? imagePicker,
  })  : _uploadCaseMedia = uploadCaseMedia,
        _caseId = caseId,
        _imagePicker = imagePicker ?? ImagePicker(),
        super(const UploadMediaState());

  final UploadCaseMediaUseCase _uploadCaseMedia;
  final int _caseId;
  final ImagePicker _imagePicker;

  void setDescription(String value) {
    emit(state.copyWith(description: value));
  }

  /// Picks a single image from [source] (camera or gallery).
  Future<void> pickImage(ImageSource source) async {
    final file = await _imagePicker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 2000,
    );
    if (file == null) return;
    emit(state.copyWith(imagePath: file.path, clearError: true));
  }

  void removeImage() {
    emit(state.copyWith(clearImage: true));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emit(state.copyWith(status: UploadMediaStatus.submitting, clearError: true));

    final result = await _uploadCaseMedia(
      UploadCaseMediaParams(
        caseId: _caseId,
        items: [
          CaseMediaUpload(
            imagePath: state.imagePath!,
            description: state.description.trim(),
          ),
        ],
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UploadMediaStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: UploadMediaStatus.success)),
    );
  }
}