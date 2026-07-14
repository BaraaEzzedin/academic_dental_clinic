import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_style.dart';
import '../../domain/entities/user_entity.dart';

class PatientHome extends StatelessWidget {
  const PatientHome({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontalPadding,
            vertical: AppDimensions.xxl,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: AppColors.primary,
                size: 80,
              ),
              const SizedBox(height: AppDimensions.xl),
              Text(
                'Welcome, ${user.fullName}',
                textAlign: TextAlign.center,
                style: AppTextStyles.welcome,
              ),
              const SizedBox(height: AppDimensions.md),
              Text(
                'You are signed in as ${user.role.name}.',
                textAlign: TextAlign.center,
                style: AppTextStyles.loginText,
              ),
              const SizedBox(height: AppDimensions.sm),
              Text(
                'Patient ID: ${user.id}',
                textAlign: TextAlign.center,
                style: AppTextStyles.hint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
