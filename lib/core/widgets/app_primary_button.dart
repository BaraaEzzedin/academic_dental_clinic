import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_text_style.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailingIcon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;

  /// When true the button is disabled and shows a loading indicator.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
            ],
            Text(label, style: AppTextStyles.button),
            if (!isLoading && trailingIcon != null) ...[
              const SizedBox(width: AppDimensions.sm),
              Icon(
                trailingIcon,
                size: AppDimensions.iconSize,
                color: AppColors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}