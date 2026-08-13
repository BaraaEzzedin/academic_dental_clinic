import 'package:dio/dio.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../models/case_details_model.dart';

abstract class CaseDetailsRemoteDataSource {
  Future<CaseDetailsModel> getCaseDetails(int caseId);
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
    }
  }
}
