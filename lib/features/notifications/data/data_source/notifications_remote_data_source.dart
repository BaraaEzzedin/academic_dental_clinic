import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/network_exception_mapper.dart';
import '../models/app_notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<AppNotificationModel>> getNotifications();
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  const NotificationsRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<List<AppNotificationModel>> getNotifications() async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        ApiConstants.notifications,
      );
      // Response shape: data.notifications[] (+ unreadCount, meta).
      final data = response.data?['data'] as Map<String, dynamic>?;
      final notifications =
          data?['notifications'] as List<dynamic>? ?? const [];
      return notifications
          .map((e) => AppNotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    } on Object catch (e) {
      throw ServerException('Failed to parse notifications: $e');
    }
  }
}
