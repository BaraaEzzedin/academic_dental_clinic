import 'package:dio/dio.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../models/assigned_patient_details_model.dart';
import '../models/assigned_patient_model.dart';

abstract class AssignedPatientsRemoteDataSource {
  Future<List<AssignedPatientModel>> getAssignedPatients();
  Future<AssignedPatientDetailsModel> getAssignedPatientDetails(int caseId);

  /// Releases the assigned case [caseId] back to open/unassigned.
  Future<void> cancelAssignedCase(int caseId);
}

class AssignedPatientsRemoteDataSourceImpl
    implements AssignedPatientsRemoteDataSource {
  const AssignedPatientsRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<List<AssignedPatientModel>> getAssignedPatients() async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.assignedCases,
      );
      final data = response.data?['data'] as List<dynamic>? ?? const [];
      return data
          .map((e) =>
              AssignedPatientModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<AssignedPatientDetailsModel> getAssignedPatientDetails(
    int caseId,
  ) async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.assignedCaseDetails(caseId),
      );
      final data = response.data?['data'] as Map<String, dynamic>? ?? const {};
      return AssignedPatientDetailsModel.fromJson(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> cancelAssignedCase(int caseId) async {
    try {
      await apiClient.patch<Map<String, dynamic>>(
        ApiConstants.cancelAssignedCase(caseId),
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}