import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../models/session.dart';

// Status-dependent action bar shown at the bottom of a session card.
class SessionActions extends StatelessWidget {
  const SessionActions({
    super.key,
    required this.status,
    this.onShareSummary,
    this.onEdit,
  });

  final SessionStatus status;
  final VoidCallback? onShareSummary;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case SessionStatus.completed:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onShareSummary,
            icon: const Icon(Icons.ios_share_rounded, size: 18),
            label: const Text('Share Summary'),
            style: _outlinedStyle,
          ),
        );
      case SessionStatus.inProgress:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit Session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              textStyle:
                  AppTextStyles.viewDetailsButton.copyWith(color: AppColors.white),
            ),
          ),
        );
      case SessionStatus.planned:
        return const SizedBox.shrink();
    }
  }

  ButtonStyle get _outlinedStyle => OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        textStyle: AppTextStyles.viewDetailsButton,
      );
}