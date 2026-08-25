import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/network_exception_mapper.dart';
import '../models/auth_response_model.dart';


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
      final response = await apiClient.post<void>(
        ApiConstants.requestOtp,
        data: {'phone': phone},
      );
      developer.log(
        'Request OTP status code: ${response.statusCode}',
        name: 'AUTH',
      );
    } on DioException catch (e) {
      developer.log(
        'Request OTP error status code: ${e.response?.statusCode}',
        name: 'AUTH',
      );
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
          'otp': code,
        },
      );
      developer.log(
        'Verify OTP status code: ${response.statusCode}',
        name: 'AUTH',
      );
      return AuthResponseModel.fromJson(response.data!);
    } on DioException catch (e) {
      developer.log(
        'Verify OTP error status code: ${e.response?.statusCode}',
        name: 'AUTH',
      );
      throw mapDioException(e);
    }
  }
}