import 'dart:convert';
import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/notifications/presentation/screens/notifications_screen.dart';

/// Global navigator key so notification taps can push routes without a
/// BuildContext. Wired to `MaterialApp.navigatorKey` in main.dart.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Handles messages received while the app is terminated or in the background.
///
/// Must be a top-level (or static) function annotated with `vm:entry-point`
/// because the plugin runs it in a separate isolate. Messages that carry a
/// `notification` block are shown in the system tray automatically, so there
/// is nothing to display here.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  developer.log('Background message: ${message.messageId}', name: 'FCM');
}

/// Wraps [FirebaseMessaging] and [FlutterLocalNotificationsPlugin] so the app
/// depends on a single surface. Responsible for permission, the device token,
/// and turning every incoming [RemoteMessage] into an on-device notification.
class PushNotificationService {
  PushNotificationService({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _localNotifications =
            localNotifications ?? FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  /// Must match the backend's `android.notification.channelId`.
  static const AndroidNotificationChannel _appointmentsChannel =
      AndroidNotificationChannel(
    'appointments',
    'Appointments',
    description: 'Appointment reminders and clinical updates.',
    importance: Importance.high,
  );

  /// Sets up the local-notifications plugin, creates the Android channel, and
  /// starts listening for foreground messages and taps. Call once at startup.
  Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) =>
          _openNotifications(response.payload),
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_appointmentsChannel);

    // Foreground messages: FCM never shows these itself, so we display them.
    FirebaseMessaging.onMessage.listen(_showNotification);

    // App opened by tapping a tray notification (from background).
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => _openNotifications(jsonEncode(message.data)));

    // App launched from terminated by tapping a notification.
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _openNotifications(jsonEncode(initialMessage.data));
    }
  }

  /// Asks the user for notification permission (shows the Android 13+ prompt).
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<String?> getToken() => _messaging.getToken();

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  Future<void> deleteToken() => _messaging.deleteToken();

  /// Parses a [RemoteMessage] and posts it as a local notification.
  void _showNotification(RemoteMessage message) {
    final notification = message.notification;
    // Data-only messages have nothing to display; ignore them here.
    if (notification == null) return;

    final android = notification.android;
    final channelId = android?.channelId ?? _appointmentsChannel.id;

    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          _channelNameFor(channelId),
          channelDescription: _appointmentsChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      // Carry the data payload (notificationId, type, …) so a tap can route.
      payload: jsonEncode(message.data),
    );
  }

  void _openNotifications(String? payload) {
    developer.log('Notification tapped: $payload', name: 'FCM');
    rootNavigatorKey.currentState?.push(
      MaterialPageRoute<void>(builder: (_) => const NotificationsScreen()),
    );
  }

  String _channelNameFor(String channelId) {
    if (channelId == _appointmentsChannel.id) return _appointmentsChannel.name;
    return 'General';
  }
}
