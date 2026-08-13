import 'package:equatable/equatable.dart';

enum UploadMediaStatus { idle, submitting, success, failure }

class UploadMediaState extends Equatable {
  const UploadMediaState({
    this.description = '',
    this.imagePath,
    this.status = UploadMediaStatus.idle,
    this.errorMessage,
  });

  final String description;
  final String? imagePath;
  final UploadMediaStatus status;
  final String? errorMessage;

  bool get isSubmitting => status == UploadMediaStatus.submitting;
  bool get hasImage => imagePath != null;

  /// Upload is allowed only with a non-empty description, a picked image,
  /// and no in-flight request (prevents duplicate submissions).
  bool get canSubmit =>
      description.trim().isNotEmpty && hasImage && !isSubmitting;

  UploadMediaState copyWith({
    String? description,
    String? imagePath,
    bool clearImage = false,
    UploadMediaStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return UploadMediaState(
      description: description ?? this.description,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [description, imagePath, status, errorMessage];
}