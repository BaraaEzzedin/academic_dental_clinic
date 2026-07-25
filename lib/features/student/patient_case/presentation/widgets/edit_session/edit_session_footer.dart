import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_text_style.dart';

// Pinned "Cancel" / "Update Session" action bar, safe-area aware.
class EditSessionFooter extends StatelessWidget {
  const EditSessionFooter({
    super.key,
    required this.onCancel,
    required this.onUpdate,
  });

  final VoidCallback onCancel;
  final VoidCallback onUpdate;

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
              onPressed: onCancel,
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
              onPressed: onUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                textStyle: AppTextStyles.button,
              ),
              child: const Text('Complete Session'),
            ),
          ),
        ],
      ),
    );
  }
}