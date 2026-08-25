import 'package:equatable/equatable.dart';

/// A single media item to upload to a case: the local image [imagePath]
/// and its [description]. The upload API accepts a list of these so
/// multi-image uploads can reuse the exact same structure in the future.
class CaseMediaUpload extends Equatable {
  const CaseMediaUpload({
    required this.imagePath,
    required this.description,
  });

  final String imagePath;
  final String description;

  @override
  List<Object?> get props => [imagePath, description];
}