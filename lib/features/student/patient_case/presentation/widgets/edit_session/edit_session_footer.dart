import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_text_style.dart';

class EditSessionFooter extends StatelessWidget {
  const EditSessionFooter({
    super.key,
    required this.onCancel,
    required this.onUpdate,
    this.isSubmitting = false,
  });

  final VoidCallback onCancel;
  final VoidCallback onUpdate;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.dividerLine)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimensions.xl,
        AppDimensions.lg,
        AppDimensions.xl,
        AppDimensions.lg + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isSubmitting ? null : onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.cardBorder),
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                textStyle: AppTextStyles.button.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                disabledBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.6),
                disabledForegroundColor: AppColors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                textStyle: AppTextStyles.button,
              ),
              child: isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.white),
                      ),
                    )
                  : const Text('Complete Session'),
            ),
          ),
        ],
      ),
    );
  }
}