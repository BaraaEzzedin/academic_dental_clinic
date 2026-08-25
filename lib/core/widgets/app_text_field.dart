import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_text_style.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.maxLines = 1,
    this.minLines,
  });

  final String? label;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.fieldLabel),
          const SizedBox(height: AppDimensions.sm),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppTextStyles.input,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: AppTextStyles.hint,
            filled: true,
            fillColor: AppColors.fieldFill,
            prefixIcon: prefixIcon == null
                ? null
                : Icon(
              prefixIcon,
              color: AppColors.textSecondary,
              size: AppDimensions.iconSize,
            ),
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.lg,
              vertical: AppDimensions.lg,
            ),
            errorStyle: AppTextStyles.error,
            border: _border(AppColors.fieldBorder),
            enabledBorder: _border(AppColors.fieldBorder),
            focusedBorder: _border(AppColors.primary),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    borderSide: BorderSide(color: color),
  );
}