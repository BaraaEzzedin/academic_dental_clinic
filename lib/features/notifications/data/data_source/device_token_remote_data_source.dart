import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/network_exception_mapper.dart';

abstract class DeviceTokenRemoteDataSource {
  Future<void> registerToken(String token);
}

class DeviceTokenRemoteDataSourceImpl implements DeviceTokenRemoteDataSource {
  const DeviceTokenRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<void> registerToken(String token) async {
    try {
      await apiClient.post<Map<String, dynamic>>(
        ApiConstants.registerDeviceToken,
        data: {'token': token, 'platform': 'android'},
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    } on Object catch (e) {
      throw ServerException('Failed to register device token: $e');
    }
  }
}