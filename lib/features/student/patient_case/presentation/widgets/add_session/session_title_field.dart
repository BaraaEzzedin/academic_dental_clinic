import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_text_style.dart';


class SessionTitleField extends StatelessWidget {
  const SessionTitleField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.enabled = true,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Session Title', style: AppTextStyles.fieldLabel),
        const SizedBox(height: AppDimensions.sm),
        TextField(
          controller: controller,
          enabled: enabled,
          onChanged: onChanged,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          style: AppTextStyles.input,
          decoration: InputDecoration(
            hintText: 'e.g. Canal Shaping & Cleaning',
            hintStyle: AppTextStyles.hint,
            filled: true,
            fillColor: AppColors.caseChipBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.lg,
              vertical: AppDimensions.md,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}