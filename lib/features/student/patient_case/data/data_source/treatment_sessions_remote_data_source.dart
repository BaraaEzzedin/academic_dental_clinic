import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../domain/repositories/treatment_sessions_repository.dart'
    show PerformedProcedure;
import '../models/session_procedures_model.dart';
import '../models/session_summary_model.dart';
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

  /// Fetches the planned procedures + progress for [treatmentSessionId].
  Future<SessionProceduresModel> getPlannedProcedures(int treatmentSessionId);

  /// Fetches the summary of the completed session [sessionId].
  Future<SessionSummaryModel> getSessionSummary(int sessionId);

  /// Starts the upcoming session [treatmentSessionId].
  Future<void> startSession(int treatmentSessionId);

  /// Edits the upcoming session [treatmentSessionId]. Only non-null fields are
  /// sent (title-only, or appointment date + start together).
  Future<void> editSession({
    required int treatmentSessionId,
    String? title,
    DateTime? appointmentDate,
    String? appointmentStart,
  });

  /// Completes the session [treatmentSessionId] with the student notes, the
  /// selected [materialIds] and the [performedProcedures] statuses.
  Future<void> completeSession({
    required int treatmentSessionId,
    required String studentNotes,
    required List<int> materialIds,
    required List<PerformedProcedure> performedProcedures,
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

  @override
  Future<SessionProceduresModel> getPlannedProcedures(
    int treatmentSessionId,
  ) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.plannedProcedures(treatmentSessionId),
      );
      final data = response.data?['data'] as Map<String, dynamic>? ?? const {};
      return SessionProceduresModel.fromJson(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    } on Object catch (e) {
      throw ServerException('Failed to parse planned procedures: $e');
    }
  }

  @override
  Future<SessionSummaryModel> getSessionSummary(int sessionId) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.sessionSummary(sessionId),
      );
      final data = response.data?['data'] as Map<String, dynamic>? ?? const {};
      return SessionSummaryModel.fromJson(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    } on Object catch (e) {
      throw ServerException('Failed to parse session summary: $e');
    }
  }

  @override
  Future<void> completeSession({
    required int treatmentSessionId,
    required String studentNotes,
    required List<int> materialIds,
    required List<PerformedProcedure> performedProcedures,
  }) async {
    try {
      final data = <String, dynamic>{
        'studentNotes': studentNotes,
        'materials': materialIds.map((id) => {'materialId': id}).toList(),
        'performedProcedures': performedProcedures
            .map((p) => {
                  'plannedProcedureId': p.plannedProcedureId,
                  'status': p.status,
                })
            .toList(),
      };
      await apiClient.patch<Map<String, dynamic>>(
        ApiConstants.completeTreatmentSession(treatmentSessionId),
        data: data,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> startSession(int treatmentSessionId) async {
    try {
      await apiClient.patch<Map<String, dynamic>>(
        ApiConstants.startTreatmentSession(treatmentSessionId),
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> editSession({
    required int treatmentSessionId,
    String? title,
    DateTime? appointmentDate,
    String? appointmentStart,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (appointmentDate != null) {
        data['appointmentDate'] = DateFormatter.toIsoDate(appointmentDate);
      }
      if (appointmentStart != null) {
        data['appointmentStart'] = appointmentStart;
      }
      await apiClient.patch<Map<String, dynamic>>(
        ApiConstants.editTreatmentSession(treatmentSessionId),
        data: data,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}