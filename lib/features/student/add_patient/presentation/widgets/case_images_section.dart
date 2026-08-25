import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/sheet_grabber.dart';
import '../../../patient_case/presentation/widgets/media_section_card.dart';
import '../manager/add_patient/add_patient_cubit.dart';
import '../manager/add_patient/add_patient_state.dart';

/// Case-level images (not tied to a tooth or procedure). Reuses the same
/// [MediaSectionCard] + "Add Media" button as Case Details, but collects the
/// files locally (they are uploaded with the walk-in request at submit time).
class CaseImagesSection extends StatelessWidget {
  const CaseImagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddPatientCubit>();
    return BlocBuilder<AddPatientCubit, AddPatientState>(
      buildWhen: (p, c) => p.imagePaths != c.imagePaths,
      builder: (context, state) {
        final Widget body = state.imagePaths.isEmpty
            ? const MediaEmptyState(message: 'No images added yet')
            : SizedBox(
                height: 108,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: state.imagePaths.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppDimensions.md),
                  itemBuilder: (context, index) {
                    final path = state.imagePaths[index];
                    return _ImagePreview(
                      path: path,
                      onRemove: () => cubit.removeImage(path),
                    );
                  },
                ),
              );
        return MediaSectionCard(
          title: 'Case Images',
          body: body,
          onAddMedia: () => _showSourcePicker(context, cubit),
        );
      },
    );
  }

  Future<void> _showSourcePicker(
    BuildContext context,
    AddPatientCubit cubit,
  ) async {
    final choice = await showModalBottomSheet<_ImageSource>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      builder: (_) => const _SourcePicker(),
    );
    switch (choice) {
      case _ImageSource.camera:
        await cubit.captureImage();
      case _ImageSource.gallery:
        await cubit.pickImagesFromGallery();
      case null:
        break;
    }
  }
}

enum _ImageSource { camera, gallery }

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.path, required this.onRemove});

  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            child: Image.file(
              File(path),
              width: 108,
              height: 108,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: AppDimensions.xs,
            right: AppDimensions.xs,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onRemove,
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(Icons.close_rounded,
                      size: 18, color: AppColors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SourcePicker extends StatelessWidget {
  const _SourcePicker();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetGrabber(),
          const SizedBox(height: AppDimensions.sm),
          ListTile(
            leading: const Icon(Icons.photo_camera_rounded,
                color: AppColors.primary),
            title: Text('Camera', style: AppTextStyles.sectionTitle),
            onTap: () => Navigator.of(context).pop(_ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_rounded,
                color: AppColors.primary),
            title: Text('Gallery', style: AppTextStyles.sectionTitle),
            onTap: () => Navigator.of(context).pop(_ImageSource.gallery),
          ),
          const SizedBox(height: AppDimensions.md),
        ],
      ),
    );
  }
}
