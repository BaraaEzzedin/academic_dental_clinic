import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../patient_case/presentation/models/diagnostic_media_item.dart';
import '../../../patient_case/presentation/widgets/diagnostic_media_thumbnail.dart';
import '../../../patient_case/presentation/widgets/progress_timeline_section.dart';
import '../../domain/entities/open_case_details_entity.dart';


class OpenCaseMediaCard extends StatelessWidget {
  const OpenCaseMediaCard({super.key, required this.media});

  final List<CaseMediaEntity> media;

  @override
  Widget build(BuildContext context) {
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Media'),
          const SizedBox(height: AppDimensions.md),
          if (media.isEmpty)
            const _EmptyMedia()
          else
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: media.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppDimensions.md),
                itemBuilder: (context, index) {
                  final item = media[index];
                  return DiagnosticMediaThumbnail(
                    item: DiagnosticMediaItem(
                      label: item.label,
                      date: item.date,
                      imageUrl: item.imageUrl,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyMedia extends StatelessWidget {
  const _EmptyMedia();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.xl),
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.perm_media_outlined,
            size: 32,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'No media attached to this case yet.',
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 13.5,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}