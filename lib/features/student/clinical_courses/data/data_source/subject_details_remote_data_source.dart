import 'package:dio/dio.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../models/subject_details_model.dart';

abstract class SubjectDetailsRemoteDataSource {
  Future<SubjectDetailsModel> getSubjectDetails(int subjectId);
}

class SubjectDetailsRemoteDataSourceImpl
    implements SubjectDetailsRemoteDataSource {
  const SubjectDetailsRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<SubjectDetailsModel> getSubjectDetails(int subjectId) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.subjectDetails(subjectId),
      );
      final data = response.data?['data'] as Map<String, dynamic>? ?? const {};
      return SubjectDetailsModel.fromJson(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
