import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../core/constants/app_colors.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.onToggleObscure,
    this.onChanged,
    this.onSubmitted,
    this.validator,
  });

  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleObscure;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: 'Password',
      controller: controller,
      hintText: 'Enter password',
      prefixIcon: Icons.lock_outline,
      obscureText: obscureText,
      textInputAction: TextInputAction.done,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      suffix: IconButton(
        onPressed: onToggleObscure,
        icon: Icon(
          obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.textSecondary,
          size: AppDimensions.iconSize,
        ),
      ),
    );
  }
}