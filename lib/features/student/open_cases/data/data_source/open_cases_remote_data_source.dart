import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../models/open_case_details_model.dart';
import '../models/open_case_model.dart';

abstract class OpenCasesRemoteDataSource {
  Future<List<OpenCaseModel>> getOpenCases();
  Future<OpenCaseDetailsModel> getOpenCaseDetails(int id);
}

class OpenCasesRemoteDataSourceImpl implements OpenCasesRemoteDataSource {
  const OpenCasesRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<List<OpenCaseModel>> getOpenCases() async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.openCases,
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      final openCases = data?['openCases'] as List<dynamic>? ?? const [];
      return openCases
          .map((e) => OpenCaseModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    } on Object catch (e) {
      throw ServerException('Failed to parse open cases: $e');
    }
  }

  @override
  Future<OpenCaseDetailsModel> getOpenCaseDetails(int id) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.openCaseDetails(id),
      );
      final data = response.data?['data'] as Map<String, dynamic>? ?? const {};
      return OpenCaseDetailsModel.fromJson(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    } on Object catch (e) {
      throw ServerException('Failed to parse open case details: $e');
    }
  }
}