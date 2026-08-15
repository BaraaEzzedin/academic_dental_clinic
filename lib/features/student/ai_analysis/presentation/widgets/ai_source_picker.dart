import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/sheet_grabber.dart';

/// Camera / Gallery chooser — same interaction and styling as the "Add Media"
/// source picker. Resolves to the chosen [ImageSource] (or null if dismissed).
Future<ImageSource?> showAiImageSourcePicker(BuildContext context) {
  return showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimensions.radiusXl),
      ),
    ),
    builder: (_) => const _AiSourcePicker(),
  );
}

class _AiSourcePicker extends StatelessWidget {
  const _AiSourcePicker();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetGrabber(),
          const SizedBox(height: AppDimensions.sm),
          ListTile(
            leading: const Icon(
              Icons.photo_camera_rounded,
              color: AppColors.primary,
            ),
            title: Text('Camera', style: AppTextStyles.sectionTitle),
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(
              Icons.photo_library_rounded,
              color: AppColors.primary,
            ),
            title: Text('Gallery', style: AppTextStyles.sectionTitle),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
          const SizedBox(height: AppDimensions.md),
        ],
      ),
    );
  }
}
