import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../models/ai_analysis_model.dart';

abstract class AiAnalysisRemoteDataSource {
  Future<AiAnalysisModel> analyze(String imagePath);
}

class AiAnalysisRemoteDataSourceImpl implements AiAnalysisRemoteDataSource {
  const AiAnalysisRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<AiAnalysisModel> analyze(String imagePath) async {
    try {
      final filename = imagePath.split(RegExp(r'[\\/]')).last;
      final formData = FormData()
        ..files.add(
          MapEntry(
            'file',
            await MultipartFile.fromFile(
              imagePath,
              filename: filename,
              // Tag the part with its image MIME type — without this Dio sends
              // application/octet-stream and the AI service rejects it (500).
              contentType: DioMediaType.parse(_mimeTypeFor(filename)),
            ),
          ),
        );

      developer.log(
        'POST ${ApiConstants.aiAnalyze} '
        'field=file filename=$filename '
        'mime=${_mimeTypeFor(filename)} '
        'files=${formData.files.length}',
        name: 'AI-Analyze',
      );

      // Let Dio compute the multipart Content-Type (with boundary) itself —
      // passing Options(contentType: 'multipart/form-data') can drop the
      // boundary and make the server fail to parse the upload.
      final response = await apiClient.post<Map<String, dynamic>>(
        ApiConstants.aiAnalyze,
        data: formData,
      );

      final data = response.data?['data'] as Map<String, dynamic>? ?? const {};
      return AiAnalysisModel.fromJson(data);
    } on DioException catch (e) {
      developer.log(
        'AI analyze failed: status=${e.response?.statusCode} '
        'sentContentType=${e.requestOptions.headers['content-type'] ?? e.requestOptions.contentType} '
        'hasAuth=${e.requestOptions.headers.containsKey('Authorization')} '
        'responseBody=${e.response?.data}',
        name: 'AI-Analyze',
        error: e,
      );
      throw mapDioException(e);
    } on Object catch (e) {
      throw ServerException('Failed to parse AI analysis: $e');
    }
  }

  /// Maps a file extension to an image MIME type so the multipart part is
  /// tagged correctly (defaults to JPEG, which image_picker produces).
  String _mimeTypeFor(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      case 'jpg':
      case 'jpeg':
      default:
        return 'image/jpeg';
    }
  }
}
