import 'package:dio/dio.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../models/today_appointment_model.dart';

abstract class TodayAppointmentsRemoteDataSource {
  Future<List<TodayAppointmentModel>> getTodayAppointments();
}

class TodayAppointmentsRemoteDataSourceImpl
    implements TodayAppointmentsRemoteDataSource {
  const TodayAppointmentsRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<List<TodayAppointmentModel>> getTodayAppointments() async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.todayAppointments,
      );
      final data = response.data?['data'] as List<dynamic>? ?? const [];
      return data
          .map((e) =>
              TodayAppointmentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}