import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.date,
    required this.greeting,
    required this.summary,
  });

  final String date;
  final String greeting;
  final String summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date, style: AppTextStyles.homeDateLabel),
        const SizedBox(height: AppDimensions.sm),
        Text(greeting, style: AppTextStyles.homeGreeting),
        const SizedBox(height: AppDimensions.md),
        Text(summary, style: AppTextStyles.homeSummary),
      ],
    );
  }
}