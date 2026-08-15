import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/ai_analysis_result.dart';
import '../../domain/entities/ai_finding.dart';
import 'ai_section_header.dart';

/// Success UI: the list of AI findings followed by the annotated image the
/// service returned. Uses the app's existing cards, colours, and typography.
class AiFindingsView extends StatelessWidget {
  const AiFindingsView({super.key, required this.result});

  final AiAnalysisResult result;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AiSectionHeader(
          title: 'AI Findings',
          icon: Icons.biotech_rounded,
        ),
        const SizedBox(height: AppDimensions.md),
        if (result.findings.isEmpty)
          Text(
            'No findings were detected in this image.',
            style: AppTextStyles.subtitle,
          )
        else
          ...result.findings.map(
            (finding) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.md),
              child: _FindingCard(finding: finding),
            ),
          ),
        if (result.imageUrl.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.lg),
          const AiSectionHeader(
            title: 'Annotated Image',
            icon: Icons.image_search_rounded,
          ),
          const SizedBox(height: AppDimensions.md),
          _AnnotatedImage(url: result.imageUrl),
        ],
      ],
    );
  }
}

class _FindingCard extends StatelessWidget {
  const _FindingCard({required this.finding});

  final AiFinding finding;

  @override
  Widget build(BuildContext context) {
    final markerColor = _markerColor(finding.color);
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 3),
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: markerColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cardBorder),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      finding.condition,
                      style: AppTextStyles.patientName,
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_outlined,
                          size: 14,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            finding.region,
                            style: AppTextStyles.scheduleSubject,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '${finding.confidencePercent}%',
                style: AppTextStyles.caseHighlightValue,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            child: LinearProgressIndicator(
              value: finding.confidence.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AppColors.fieldBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  /// Maps the model's colour name onto the app palette, falling back to the
  /// brand primary for anything unrecognised.
  Color _markerColor(String name) {
    switch (name.trim().toLowerCase()) {
      case 'green':
        return AppColors.success;
      case 'blue':
        return const Color(0xFF2F80ED);
      case 'white':
        return AppColors.white;
      case 'red':
        return AppColors.error;
      case 'yellow':
      case 'amber':
        return AppColors.warning;
      case 'orange':
        return AppColors.accentCoral;
      default:
        return AppColors.primary;
    }
  }
}

class _AnnotatedImage extends StatelessWidget {
  const _AnnotatedImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: AspectRatio(
        aspectRatio: 16 / 11,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              color: AppColors.fieldFill,
              alignment: Alignment.center,
              child: const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            color: AppColors.fieldFill,
            alignment: Alignment.center,
            child: const Icon(
              Icons.broken_image_outlined,
              color: AppColors.textHint,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
