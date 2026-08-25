import 'package:academic_dental_clinic/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PatientRegister extends StatelessWidget {
  const PatientRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(
        child: Text("Register"),
      ),
    );
  }
}
