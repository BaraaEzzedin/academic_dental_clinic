import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../patient_case/presentation/widgets/progress_timeline_section.dart';

class MedicalInformationCard extends StatelessWidget {
  const MedicalInformationCard({
    super.key,
    required this.currentMedications,
    required this.medicalConditions,
    required this.allergies,
  });

  final List<String> currentMedications;
  final List<String> medicalConditions;
  final List<String> allergies;

  static const String _placeholder = 'No information provided';

  @override
  Widget build(BuildContext context) {
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Medical Information'),
          const SizedBox(height: AppDimensions.lg),
          _MedicalSection(
            title: 'Current Medications',
            icon: Icons.medication_outlined,
            accent: AppColors.primary,
            items: currentMedications,
            placeholder: _placeholder,
          ),
          const _SectionDivider(),
          _MedicalSection(
            title: 'Medical Conditions / Diseases',
            icon: Icons.monitor_heart_outlined,
            accent: AppColors.secondary,
            items: medicalConditions,
            placeholder: _placeholder,
          ),
          const _SectionDivider(),
          _MedicalSection(
            title: 'Allergies',
            icon: Icons.warning_amber_rounded,
            accent: AppColors.warning,
            items: allergies,
            placeholder: _placeholder,
          ),
        ],
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.lg),
      child: Divider(height: 1, color: AppColors.dividerLine),
    );
  }
}

class _MedicalSection extends StatelessWidget {
  const _MedicalSection({
    required this.title,
    required this.icon,
    required this.accent,
    required this.items,
    required this.placeholder,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final List<String> items;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              child: Text(title, style: AppTextStyles.timelinePhaseTitle),
            ),
            if (items.isNotEmpty) _CountBadge(count: items.length, accent: accent),
          ],
        ),
        const SizedBox(height: AppDimensions.md),
        if (items.isEmpty)
          _EmptyValue(message: placeholder)
        else
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: AppDimensions.sm),
            _InfoRow(text: items[i], accent: accent),
          ],
      ],
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
          decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(child: Text(text, style: AppTextStyles.noteMessage)),
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
      child: Text('$count', style: AppTextStyles.noteMeta.copyWith(color: accent)),
    );
  }
}

class _EmptyValue extends StatelessWidget {
  const _EmptyValue({required this.message});

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