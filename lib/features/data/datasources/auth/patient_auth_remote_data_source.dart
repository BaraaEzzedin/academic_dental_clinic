import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/network_exception_mapper.dart';
import '../../models/auth_response_model.dart';


abstract class PatientAuthRemoteDataSource {

  Future<void> requestOtp({required String phone});

  Future<AuthResponseModel> verifyOtp({
    required String phone,
    required String code,
  });
}

class PatientAuthRemoteDataSourceImpl implements PatientAuthRemoteDataSource {
  const PatientAuthRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<void> requestOtp({required String phone}) async {
    try {
      await apiClient.post<void>(
        ApiConstants.requestOtp,
        data: {'phone': phone},
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<AuthResponseModel> verifyOtp({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        ApiConstants.verifyOtp,
        data: {
          'phone': phone,
          'code': code,
        },
      );
      return AuthResponseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}