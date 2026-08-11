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
    // TODO(backend): replace the mock below with the real request once the
    // acceptance-request endpoint is finalised:
    //
    //   await apiClient.post<Map<String, dynamic>>(
    //     ApiConstants.caseAcceptanceRequests,
    //     data: request.toJson(),
    //   );
    //
    // Wrap in `try/on DioException` and rethrow via `mapDioException`.
    // `request.toJson()` already emits the per-type answer payload.
    await Future<void>.delayed(const Duration(milliseconds: 900));
  }
}