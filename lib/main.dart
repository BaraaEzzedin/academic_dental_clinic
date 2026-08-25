import 'package:academic_dental_clinic/core/navigation/app_route_observer.dart';
import 'package:academic_dental_clinic/core/notifications/push_notification_service.dart';
import 'package:academic_dental_clinic/core/service_locator/auth_service.dart';
import 'package:academic_dental_clinic/features/auth/presentation/screens/select_role.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  configureDependencies();
  // Set up local notifications + the "appointments" channel and start
  // displaying foreground messages / handling taps.
  await sl<PushNotificationService>().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: rootNavigatorKey,
      navigatorObservers: [appRouteObserver],
      home: SelectRole(),
    );
  }
}

