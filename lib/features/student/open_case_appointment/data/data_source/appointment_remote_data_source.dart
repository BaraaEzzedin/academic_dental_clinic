import 'package:dio/dio.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../models/available_appointments_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<AvailableAppointmentsModel> getAvailableAppointments({
    required DateTime date,
    required int subjectId,
  });

  Future<void> bookAppointment({
    required int clinicalCaseId,
    required DateTime date,
    required String time,
  });
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  const AppointmentRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<AvailableAppointmentsModel> getAvailableAppointments({
    required DateTime date,
    required int subjectId,
  }) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.availableAppointments,
        queryParameters: {
          'date': DateFormatter.toIsoDate(date),
          'subjectId': subjectId,
        },
      );
      final data = response.data?['data'] as Map<String, dynamic>? ?? const {};
      return AvailableAppointmentsModel.fromJson(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> bookAppointment({
    required int clinicalCaseId,
    required DateTime date,
    required String time,
  }) async {
    try {
      await apiClient.post<Map<String, dynamic>>(
        ApiConstants.clinicalAppointments,
        data: {
          'clinicalCaseId': clinicalCaseId,
          'appointmentDate': DateFormatter.toIsoDate(date),
          'appointmentStart': time,
        },
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}