import 'package:dio/dio.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../models/clinical_course_model.dart';

abstract class ClinicalCoursesRemoteDataSource {
  Future<List<ClinicalCourseModel>> getClinicalCourses();
}

class ClinicalCoursesRemoteDataSourceImpl
    implements ClinicalCoursesRemoteDataSource {
  const ClinicalCoursesRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<List<ClinicalCourseModel>> getClinicalCourses() async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.mySubjects,
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      final subjects = data?['subjects'] as List<dynamic>? ?? const [];
      return subjects
          .map((e) =>
          ClinicalCourseModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}