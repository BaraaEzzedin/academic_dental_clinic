import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';

/// A rounded linear progress bar used across the Subject Details screen for
/// both the overall and per-procedure progress.
class SubjectProgressBar extends StatelessWidget {
  const SubjectProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.primary,
    this.height = 8,
  });

  /// Progress fraction, 0..1.
  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: AppColors.indicatorInactive.withValues(alpha: 0.35),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
