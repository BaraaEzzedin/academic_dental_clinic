import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../domain/entities/case_media_entity.dart';
import '../models/diagnostic_media_item.dart';
import 'diagnostic_media_thumbnail.dart';
import 'progress_timeline_section.dart';

class DiagnosticMediaCard extends StatelessWidget {
  const DiagnosticMediaCard({super.key, required this.media});

  final List<CaseMediaEntity> media;

  @override
  Widget build(BuildContext context) {
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Diagnostic Media'),
          const SizedBox(height: AppDimensions.md),
          if (media.isEmpty)
            Text('No diagnostic media yet.', style: AppTextStyles.subtitle)
          else
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: media.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppDimensions.md),
                itemBuilder: (context, index) =>
                    DiagnosticMediaThumbnail(item: _toItem(media[index])),
              ),
            ),
        ],
      ),
    );
  }

  DiagnosticMediaItem _toItem(CaseMediaEntity item) {
    return DiagnosticMediaItem(
      label: item.description,
      date: item.takenAt != null
          ? DateFormatter.toMediumDate(item.takenAt!)
          : '',
      imageUrl: item.url.isEmpty ? null : item.url,
    );
  }
}
