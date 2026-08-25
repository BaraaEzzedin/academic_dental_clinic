import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_text_style.dart';

/// A compact, secondary "View All" action shown at the end of a section header
/// (title on the left, this on the right). Visually lighter than the title so
/// it reads as a supporting action.
class ViewAllButton extends StatelessWidget {
  const ViewAllButton({super.key, this.onPressed, this.label = 'View All'});

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.sm,
          vertical: AppDimensions.xs,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: AppTextStyles.viewDetailsButton,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: AppDimensions.xs),
          const Icon(Icons.arrow_forward_ios_rounded, size: 13),
        ],
      ),
    );
  }
}