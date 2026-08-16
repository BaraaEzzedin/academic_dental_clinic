import 'package:dio/dio.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../models/student_schedule_model.dart';

abstract class TodayAppointmentsRemoteDataSource {
  Future<StudentScheduleModel> getStudentSchedule();
}

class TodayAppointmentsRemoteDataSourceImpl
    implements TodayAppointmentsRemoteDataSource {
  const TodayAppointmentsRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<StudentScheduleModel> getStudentSchedule() async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.studentUpcomingAppointments,
      );
      return StudentScheduleModel.fromJson(_scheduleNode(response.data));
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  /// The `today`/`upcoming` lists live under `data`, which the backend wraps in
  /// an extra `data` envelope (`data.data.today`). Tolerates either nesting.
  Map<String, dynamic> _scheduleNode(Map<String, dynamic>? body) {
    var node = body?['data'];
    if (node is Map && node['data'] is Map) {
      node = node['data'];
    }
    if (node is Map<String, dynamic>) return node;
    if (node is Map) return node.cast<String, dynamic>();
    return const {};
  }
}