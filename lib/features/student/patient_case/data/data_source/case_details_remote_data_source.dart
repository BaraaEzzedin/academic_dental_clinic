import 'dart:convert';

import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../../domain/entities/case_media_upload.dart';
import '../models/case_details_model.dart';

abstract class CaseDetailsRemoteDataSource {
  Future<CaseDetailsModel> getCaseDetails(int caseId);

  Future<void> uploadCaseMedia({
    required int caseId,
    required List<CaseMediaUpload> items,
  });
}

class CaseDetailsRemoteDataSourceImpl implements CaseDetailsRemoteDataSource {
  const CaseDetailsRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<CaseDetailsModel> getCaseDetails(int caseId) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.myCaseDetails(caseId),
      );
      final data = response.data?['data'] as Map<String, dynamic>? ?? const {};
      return CaseDetailsModel.fromJson(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    } on Object catch (e) {
      throw ServerException('Failed to parse case details: $e');
    }
  }

  @override
  Future<void> uploadCaseMedia({
    required int caseId,
    required List<CaseMediaUpload> items,
  }) async {
    try {
      // Backend contract:
      //   media    -> one file per item (repeated field)
      //   metadata -> JSON text array, one object per file, index-aligned
      final formData = FormData();
      for (final item in items) {
        formData.files.add(
          MapEntry(
            'media',
            await MultipartFile.fromFile(
              item.imagePath,
              filename: item.imagePath.split(RegExp(r'[\\/]')).last,
            ),
          ),
        );
      }
      final metadata = jsonEncode(
        items.map((e) => {'description': e.description}).toList(),
      );
      formData.fields.add(MapEntry('metadata', metadata));

      await apiClient.post<Map<String, dynamic>>(
        ApiConstants.caseMedia(caseId),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
