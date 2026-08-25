import 'package:dio/dio.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../../domain/entities/student_dashboard_entity.dart';
import '../models/student_dashboard_model.dart';

abstract class StudentDashboardRemoteDataSource {
  Future<StudentDashboardEntity> getDashboard();
}

class StudentDashboardRemoteDataSourceImpl
    implements StudentDashboardRemoteDataSource {
  const StudentDashboardRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<StudentDashboardEntity> getDashboard() async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.studentProfile,
      );
      final data = response.data?['data'] as Map<String, dynamic>? ?? const {};
      return StudentDashboardModel.fromData(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
