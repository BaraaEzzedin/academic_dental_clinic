import 'dart:async';
import 'dart:developer' as developer;

import '../../core/notifications/push_notification_service.dart';
import '../../core/service_locator/auth_service.dart';
import 'domain/use_cases/register_device_token_use_case.dart';

/// Requests notification permission, sends the current FCM token to the backend,
/// and keeps it in sync when Firebase rotates it.
///
/// Call this once after a successful login (the backend request relies on the
/// bearer token added by `AuthInterceptor`, so a session must already exist).
StreamSubscription<String>? _refreshSubscription;

Future<void> syncDeviceToken() async {
  final service = sl<PushNotificationService>();
  final registerToken = sl<RegisterDeviceTokenUseCase>();

  try {
    final granted = await service.requestPermission();
    if (!granted) {
      developer.log('Notification permission not granted', name: 'FCM');
      return;
    }

    service.listen();

    final token = await service.getToken();
    if (token != null) {
      await registerToken(token);
    }

    // Re-register whenever Firebase issues a new token.
    await _refreshSubscription?.cancel();
    _refreshSubscription = service.onTokenRefresh.listen((newToken) {
      registerToken(newToken);
    });
  } catch (e) {
    // Never block the login flow because notifications failed to set up.
    developer.log('Failed to sync device token: $e', name: 'FCM');
  }
}