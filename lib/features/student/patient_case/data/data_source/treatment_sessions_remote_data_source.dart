import 'package:dio/dio.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../models/treatment_session_model.dart';

abstract class TreatmentSessionsRemoteDataSource {
  Future<List<TreatmentSessionModel>> getTreatmentSessions(int clinicalCaseId);

  /// Creates a treatment session for the clinical case [clinicalCaseId].
  ///
  /// The very first session has no appointment yet, so [appointmentDate] and
  /// [appointmentStart] are omitted from the request when null.
  Future<void> createTreatmentSession({
    required int clinicalCaseId,
    required String title,
    DateTime? appointmentDate,
    String? appointmentStart,
  });
}

class TreatmentSessionsRemoteDataSourceImpl
    implements TreatmentSessionsRemoteDataSource {
  const TreatmentSessionsRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<List<TreatmentSessionModel>> getTreatmentSessions(
    int clinicalCaseId,
  ) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.treatmentSessions,
        queryParameters: {'clinicalCaseId': clinicalCaseId},
      );
      final data = response.data?['data'] as List<dynamic>? ?? const [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(TreatmentSessionModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> createTreatmentSession({
    required int clinicalCaseId,
    required String title,
    DateTime? appointmentDate,
    String? appointmentStart,
  }) async {
    try {
      final data = <String, dynamic>{
        'clinicalCaseId': clinicalCaseId,
        'title': title,
      };
      if (appointmentDate != null) {
        data['appointmentDate'] = DateFormatter.toIsoDate(appointmentDate);
      }
      if (appointmentStart != null) {
        data['appointmentStart'] = appointmentStart;
      }
      await apiClient.post<Map<String, dynamic>>(
        ApiConstants.createTreatmentSession,
        data: data,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}