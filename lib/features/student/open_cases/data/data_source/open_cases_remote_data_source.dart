import 'package:dio/dio.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../models/open_case_model.dart';

abstract class OpenCasesRemoteDataSource {
  Future<List<OpenCaseModel>> getOpenCases();
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
    }
  }
}