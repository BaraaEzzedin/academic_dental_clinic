import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_text_style.dart';

/// App-wide floating snackbars, matching the visual language already used
/// across the auth and case-acceptance flows.
class AppSnackBar {
  const AppSnackBar._();

  static void showSuccess(BuildContext context, String message) => _show(
        context,
        message: message,
        icon: Icons.check_circle_rounded,
        background: AppColors.success,
      );

  static void showError(BuildContext context, String message) => _show(
        context,
        message: message,
        icon: Icons.error_outline_rounded,
        background: AppColors.error,
      );

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color background,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: background,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          content: Row(
            children: [
              Icon(icon, color: AppColors.white, size: 20),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.button.copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      );
  }
}