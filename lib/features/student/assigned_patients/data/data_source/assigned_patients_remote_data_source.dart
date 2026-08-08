import 'package:dio/dio.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/network_exception_mapper.dart';
import '../models/assigned_patient_model.dart';

abstract class AssignedPatientsRemoteDataSource {
  Future<List<AssignedPatientModel>> getAssignedPatients();
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
}