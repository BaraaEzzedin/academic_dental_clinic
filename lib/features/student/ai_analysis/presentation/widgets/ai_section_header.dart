import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';

/// A small section label (e.g. "AI Findings") with a thin underline, matching
/// the section headings used elsewhere in the app.
class AiSectionHeader extends StatelessWidget {
  const AiSectionHeader({super.key, required this.title, this.icon});

  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: AppDimensions.sm),
            ],
            Text(title, style: AppTextStyles.sectionTitle),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        const Divider(height: 1, color: AppColors.dividerLine),
      ],
    );
  }
}
