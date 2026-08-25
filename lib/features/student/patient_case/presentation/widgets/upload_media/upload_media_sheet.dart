import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/service_locator/auth_service.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../../core/widgets/app_text_field.dart';
import '../../../../../../core/widgets/sheet_grabber.dart';
import '../../../domain/use_cases/upload_case_media_use_case.dart';
import '../../manager/upload_media/upload_media_cubit.dart';
import '../../manager/upload_media/upload_media_state.dart';

/// Opens the "Add Media" bottom sheet. Resolves to `true` when a media item
/// was uploaded successfully, so the caller can refresh the case details.
Future<bool?> showUploadMediaSheet(
  BuildContext context, {
  required int caseId,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider<UploadMediaCubit>(
      create: (_) => UploadMediaCubit(
        uploadCaseMedia: sl<UploadCaseMediaUseCase>(),
        caseId: caseId,
      ),
      child: const UploadMediaSheet(),
    ),
  );
}

class UploadMediaSheet extends StatefulWidget {
  const UploadMediaSheet({super.key});

  @override
  State<UploadMediaSheet> createState() => _UploadMediaSheetState();
}

class _UploadMediaSheetState extends State<UploadMediaSheet> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, UploadMediaState state) {
    switch (state.status) {
      case UploadMediaStatus.success:
        Navigator.of(context).pop(true);
      case UploadMediaStatus.failure:
        AppSnackBar.showError(
          context,
          state.errorMessage ?? 'Failed to upload media. Please try again.',
        );
      case UploadMediaStatus.idle:
      case UploadMediaStatus.submitting:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXl),
          ),
        ),
        child: BlocConsumer<UploadMediaCubit, UploadMediaState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: _onStateChanged,
          builder: (context, state) {
            final cubit = context.read<UploadMediaCubit>();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SheetGrabber(),
                _Header(
                  onClose: state.isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(),
                ),
                const Divider(height: 1, color: AppColors.dividerLine),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          label: 'Description',
                          controller: _descriptionController,
                          hintText: 'e.g. Pre-operative panoramic X-ray',
                          textInputAction: TextInputAction.done,
                          onChanged: cubit.setDescription,
                        ),
                        const SizedBox(height: AppDimensions.lg),
                        Text('Image', style: AppTextStyles.fieldLabel),
                        const SizedBox(height: AppDimensions.sm),
                        _ImagePickerArea(
                          imagePath: state.imagePath,
                          enabled: !state.isSubmitting,
                          onPick: () => _pickSource(context, cubit),
                          onRemove: cubit.removeImage,
                        ),
                      ],
                    ),
                  ),
                ),
                _Footer(
                  canSubmit: state.canSubmit,
                  isSubmitting: state.isSubmitting,
                  onSubmit: cubit.submit,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickSource(BuildContext context, UploadMediaCubit cubit) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      builder: (_) => const _SourcePicker(),
    );
    if (source == null) return;
    await cubit.pickImage(source);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClose});

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.xl,
        AppDimensions.md,
        AppDimensions.lg,
        AppDimensions.md,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.caseChipBackground,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: const Icon(
              Icons.perm_media_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          const Expanded(
            child: Text(
              'Add Media',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
            color: AppColors.textSecondary,
            visualDensity: VisualDensity.compact,
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }
}

class _ImagePickerArea extends StatelessWidget {
  const _ImagePickerArea({
    required this.imagePath,
    required this.enabled,
    required this.onPick,
    required this.onRemove,
  });

  final String? imagePath;
  final bool enabled;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) {
      return InkWell(
        onTap: enabled ? onPick : null,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Container(
          height: 170,
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
                size: 36,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: AppDimensions.sm),
              Text('Add a photo', style: AppTextStyles.subtitle),
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
            aspectRatio: 16 / 10,
            child: Image.file(
              File(imagePath!),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Positioned(
            top: AppDimensions.sm,
            right: AppDimensions.sm,
            child: _CircleAction(
              icon: Icons.close_rounded,
              onTap: enabled ? onRemove : null,
              tooltip: 'Remove',
            ),
          ),
          Positioned(
            bottom: AppDimensions.sm,
            right: AppDimensions.sm,
            child: _CircleAction(
              icon: Icons.autorenew_rounded,
              onTap: enabled ? onPick : null,
              tooltip: 'Replace',
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 20, color: AppColors.white),
        visualDensity: VisualDensity.compact,
        tooltip: tooltip,
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

class _Footer extends StatelessWidget {
  const _Footer({
    required this.canSubmit,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final bool canSubmit;
  final bool isSubmitting;
  final VoidCallback onSubmit;

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
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canSubmit ? onSubmit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
            disabledForegroundColor: AppColors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            textStyle: AppTextStyles.button,
          ),
          child: isSubmitting
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.white),
                      ),
                    ),
                    SizedBox(width: AppDimensions.sm),
                    Text('Uploading...'),
                  ],
                )
              : const Text('Upload Media'),
        ),
      ),
    );
  }
}