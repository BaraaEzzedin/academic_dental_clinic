import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
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
      final data = response.data?['data'] as List<dynamic>? ?? const [];
      return data
          .map((e) => AppNotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      // TODO(backend): remove this fallback once the notifications endpoint is
      // live. Until then, show sample data instead of an error screen.
      developer.log(
        'Notifications endpoint unavailable, using mock data: ${e.message}',
        name: 'Notifications',
      );
      return _mockNotifications();
    } on Object catch (e) {
      throw ServerException('Failed to parse notifications: $e');
    }
  }

  List<AppNotificationModel> _mockNotifications() {
    final now = DateTime.now();
    return [
      AppNotificationModel(
        id: '1',
        title: 'New case assigned',
        body: 'A new clinical case has been assigned to you. Tap to review.',
        createdAt: now.subtract(const Duration(minutes: 12)),
      ),
      AppNotificationModel(
        id: '2',
        title: 'Appointment reminder',
        body: 'You have a treatment session scheduled tomorrow at 10:00 AM.',
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      AppNotificationModel(
        id: '3',
        title: 'Session approved',
        body: 'Your supervisor approved the summary for case #128.',
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        isRead: true,
      ),
    ];
  }
}