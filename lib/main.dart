import 'package:academic_dental_clinic/core/service_locator/auth_service.dart';
import 'package:academic_dental_clinic/features/auth/presentation/screens/select_role.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SelectRole(),
    );
  }
}

