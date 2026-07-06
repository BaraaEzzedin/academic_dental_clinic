import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_style.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key, this.label = 'OR'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.dividerLine, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          child: Text(label, style: AppTextStyles.dividerLabel),
        ),
        const Expanded(
          child: Divider(color: AppColors.dividerLine, thickness: 1),
        ),
      ],
    );
  }
}