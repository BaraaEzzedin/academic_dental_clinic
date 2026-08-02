import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// The small drag handle shown at the top of a modal bottom sheet.
class SheetGrabber extends StatelessWidget {
  const SheetGrabber({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppDimensions.md),
      width: 44,
      height: 5,
      decoration: BoxDecoration(
        color: AppColors.indicatorInactive,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
    );
  }
}