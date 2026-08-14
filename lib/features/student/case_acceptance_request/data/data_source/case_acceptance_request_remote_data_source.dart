import 'dart:convert';

import 'package:dio/dio.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../models/case_acceptance_request_model.dart';
import '../models/subject_config_model.dart';

abstract class CaseAcceptanceRequestRemoteDataSource {
  Future<SubjectConfigModel> getSubjectConfiguration(int subjectId);

  Future<void> submitAcceptanceRequest(CaseAcceptanceRequestModel request);
}

class CaseAcceptanceRequestRemoteDataSourceImpl
    implements CaseAcceptanceRequestRemoteDataSource {
  const CaseAcceptanceRequestRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<SubjectConfigModel> getSubjectConfiguration(int subjectId) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.subjectProcedures(subjectId),
      );
      final data = response.data?['data'] as Map<String, dynamic>? ?? const {};
      return SubjectConfigModel.fromJson(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> submitAcceptanceRequest(
    CaseAcceptanceRequestModel request,
  ) async {
    try {
      // Multipart contract (same shape as the walk-in request):
      //   images -> one file part per selected case image (repeated field)
      //   data   -> JSON string of the request (clinicalCaseId + procedures)
      final formData = FormData();
      for (final path in request.imagePaths) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              path,
              filename: path.split(RegExp(r'[\\/]')).last,
            ),
          ),
        );
      }
      formData.fields.add(MapEntry('data', jsonEncode(request.toJson())));

      await apiClient.post<Map<String, dynamic>>(
        ApiConstants.diagnosisSubmission,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}