import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/network_exception_mapper.dart';
import '../models/auth_response_model.dart';


abstract class StaffAuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });
}

class StaffAuthRemoteDataSourceImpl implements StaffAuthRemoteDataSource {
  const StaffAuthRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        ApiConstants.staffLogin,
        data: {
          'email': email,
          'password': password,
        },
      );
      return AuthResponseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}