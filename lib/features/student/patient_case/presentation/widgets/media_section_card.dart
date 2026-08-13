import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/app_primary_button.dart';
import 'progress_timeline_section.dart';

/// Shared media section card. Used by Case Details ("Diagnostic Media") and the
/// Add Patient case-images step so both render identical chrome, empty state and
/// "Add Media" button. The [body] is the gallery or empty state; [onAddMedia]
/// shows the primary action when non-null.
class MediaSectionCard extends StatelessWidget {
  const MediaSectionCard({
    super.key,
    required this.title,
    required this.body,
    this.onAddMedia,
    this.addLabel = 'Add Media',
  });

  final String title;
  final Widget body;
  final VoidCallback? onAddMedia;
  final String addLabel;

  @override
  Widget build(BuildContext context) {
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title),
          const SizedBox(height: AppDimensions.md),
          body,
          if (onAddMedia != null) ...[
            const SizedBox(height: AppDimensions.lg),
            AppPrimaryButton(
              label: addLabel,
              trailingIcon: Icons.add_rounded,
              onPressed: onAddMedia,
            ),
          ],
        ],
      ),
    );
  }
}

/// The empty-state block for a media section (icon + message).
class MediaEmptyState extends StatelessWidget {
  const MediaEmptyState({super.key, this.message = 'No media uploaded yet'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xl,
        horizontal: AppDimensions.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.mediaBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.image_outlined,
            size: 36,
            color: AppColors.logoBorder,
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(message, style: AppTextStyles.subtitle),
        ],
      ),
    );
  }
}
