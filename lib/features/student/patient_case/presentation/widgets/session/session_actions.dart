import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../models/session.dart';

class SessionActions extends StatelessWidget {
  const SessionActions({
    super.key,
    required this.status,
    this.onViewSummary,
    this.onEdit,
    this.onStart,
    this.onEditSchedule,
  });

  final SessionStatus status;
  final VoidCallback? onViewSummary;
  final VoidCallback? onEdit;
  final VoidCallback? onStart;

  /// Reschedule/rename an upcoming session (shown alongside Start Session).
  final VoidCallback? onEditSchedule;

  @override
  Widget build(BuildContext context) {
    // Each status shows exactly one primary action; the others are hidden.
    switch (status) {
      case SessionStatus.completed:
        // No summary callback (read-only without a summary) → no action.
        if (onViewSummary == null) return const SizedBox.shrink();
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onViewSummary,
            icon: const Icon(Icons.receipt_long_rounded, size: 18),
            label: const Text('View Summary'),
            style: _outlinedStyle,
          ),
        );
      case SessionStatus.active:
        if (onEdit == null) return const SizedBox.shrink();
        return _primaryButton(
          onPressed: onEdit,
          icon: Icons.edit_outlined,
          label: 'Edit Session',
        );
      case SessionStatus.upcoming:
        // Start Session (primary) + Edit Session (outlined, reschedule).
        final children = <Widget>[];
        if (onStart != null) {
          children.add(_primaryButton(
            onPressed: onStart,
            icon: Icons.play_arrow_rounded,
            label: 'Start Session',
          ));
        }
        if (onEditSchedule != null) {
          if (children.isNotEmpty) {
            children.add(const SizedBox(height: AppDimensions.sm));
          }
          children.add(SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onEditSchedule,
              icon: const Icon(Icons.edit_calendar_rounded, size: 18),
              label: const Text('Edit Session'),
              style: _outlinedStyle,
            ),
          ));
        }
        if (children.isEmpty) return const SizedBox.shrink();
        return Column(mainAxisSize: MainAxisSize.min, children: children);
    }
  }

  Widget _primaryButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
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