import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../models/diagnostic_media_item.dart';
import 'diagnostic_media_thumbnail.dart';
import 'progress_timeline_section.dart';

class DiagnosticMediaCard extends StatelessWidget {
  const DiagnosticMediaCard({super.key, required this.media});

  final List<DiagnosticMediaItem> media;

  @override
  Widget build(BuildContext context) {
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Diagnostic Media'),
          const SizedBox(height: AppDimensions.md),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: media.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppDimensions.md),
              itemBuilder: (context, index) =>
                  DiagnosticMediaThumbnail(item: media[index]),
            ),
          ),
        ],
      ),
    );
  }
}