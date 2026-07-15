import 'package:academic_dental_clinic/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../widgets/home_header.dart';
import '../widgets/home_top_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Static values for now — replaced by the backend response later.
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontalPadding,
            vertical: AppDimensions.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HomeTopBar(studentName: 'Student name'),
              SizedBox(height: AppDimensions.xl),
              HomeHeader(
                date: 'MONDAY, OCT 23',
                greeting: 'Good morning,\nJulian',
                summary: 'You have 3 clinical procedures scheduled for today.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}