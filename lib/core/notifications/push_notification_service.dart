import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';

/// Handles messages received while the app is terminated or in the background.
///
/// Must be a top-level (or static) function annotated with `vm:entry-point`
/// because the plugin runs it in a separate isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // The system tray already displays the notification. This handler is only
  // for any data-only processing we may need later.
  developer.log(
    'Background message: ${message.messageId}',
    name: 'FCM',
  );
}

/// Thin wrapper around [FirebaseMessaging] so the rest of the app depends on a
/// single, testable surface instead of the plugin directly.
class PushNotificationService {
  PushNotificationService([FirebaseMessaging? messaging])
      : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  /// Asks the user for notification permission (shows the Android 13+ prompt).
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  /// The current FCM registration token for this device (may be null if the
  /// device has no Google Play services or permission was denied).
  Future<String?> getToken() => _messaging.getToken();

  /// Emits a new token whenever Firebase rotates it. Re-send it to the backend.
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  /// Deletes the token (call on logout so this device stops receiving pushes).
  Future<void> deleteToken() => _messaging.deleteToken();

  /// Wires up runtime listeners. Tray-only display, so foreground messages are
  /// just logged; taps are where routing would later be added.
  void listen() {
    FirebaseMessaging.onMessage.listen((message) {
      developer.log('Foreground message: ${message.messageId}', name: 'FCM');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      developer.log('Opened from notification: ${message.messageId}',
          name: 'FCM');
      // TODO: navigate based on message.data when deep-linking is needed.
    });
  }
}