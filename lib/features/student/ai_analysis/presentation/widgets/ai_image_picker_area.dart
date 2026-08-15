import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';

/// Upload card / image preview for the AI screen. Mirrors the "Add Media"
/// picker: an empty "Add Photo" drop area, and once an image is chosen a
/// preview with a "Replace" action. The image stays visible at all times;
/// replacing is disabled while an analysis is running.
class AiImagePickerArea extends StatelessWidget {
  const AiImagePickerArea({
    super.key,
    required this.imagePath,
    required this.enabled,
    required this.onPick,
  });

  final String? imagePath;
  final bool enabled;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) {
      return InkWell(
        onTap: enabled ? onPick : null,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.fieldFill,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.fieldBorder),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate_outlined,
                size: 40,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: AppDimensions.sm),
              Text('Add Photo', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppDimensions.xs),
              Text(
                'Upload a dental image to analyze',
                style: AppTextStyles.subtitle,
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 11,
            child: Image.file(
              File(imagePath!),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Positioned(
            bottom: AppDimensions.sm,
            right: AppDimensions.sm,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: enabled ? onPick : null,
                icon: const Icon(
                  Icons.autorenew_rounded,
                  size: 20,
                  color: AppColors.white,
                ),
                visualDensity: VisualDensity.compact,
                tooltip: 'Replace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
