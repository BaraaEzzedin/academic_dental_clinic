import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../patient_case/presentation/widgets/progress_timeline_section.dart';


class MedicalInfoCard extends StatelessWidget {
  const MedicalInfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.accent,
    required this.items,
    required this.emptyMessage,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final List<String> items;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.sm),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Icon(icon, color: accent, size: AppDimensions.iconSize),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Text(title, style: AppTextStyles.sectionTitle),
              ),
              if (items.isNotEmpty) _CountBadge(count: items.length, accent: accent),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          if (items.isEmpty)
            _EmptySection(message: emptyMessage)
          else
            ...[
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(height: AppDimensions.sm),
                _InfoRow(text: items[i], accent: accent),
              ],
            ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.text, required this.accent});

  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 7),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: accent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Text(text, style: AppTextStyles.noteMessage),
        ),
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.accent});

  final int count;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Text(
        '$count',
        style: AppTextStyles.noteMeta.copyWith(color: accent),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.remove_circle_outline_rounded,
          size: 18,
          color: AppColors.textHint,
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: Text(
            message,
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 13.5,
              color: AppColors.textHint,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}