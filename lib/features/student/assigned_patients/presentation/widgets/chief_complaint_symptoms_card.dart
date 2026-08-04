import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../patient_case/presentation/widgets/progress_timeline_section.dart';

class ChiefComplaintSymptomsCard extends StatelessWidget {
  const ChiefComplaintSymptomsCard({
    super.key,
    required this.chiefComplaint,
    required this.symptoms,
  });

  final String chiefComplaint;
  final List<String> symptoms;

  @override
  Widget build(BuildContext context) {
    final complaint = chiefComplaint.trim();
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Chief Complaint'),
          const SizedBox(height: AppDimensions.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.caseChipBackground,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Text(
              complaint.isEmpty ? 'No chief complaint recorded.' : complaint,
              style: AppTextStyles.noteMessage.copyWith(
                color: complaint.isEmpty
                    ? AppColors.textHint
                    : AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          Text('SYMPTOMS', style: AppTextStyles.caseFieldLabel),
          const SizedBox(height: AppDimensions.md),
          if (symptoms.isEmpty)
            Text(
              'No symptoms recorded.',
              style: AppTextStyles.subtitle.copyWith(
                fontSize: 13.5,
                color: AppColors.textHint,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Wrap(
              spacing: AppDimensions.sm,
              runSpacing: AppDimensions.sm,
              children: [
                for (final symptom in symptoms) _SymptomChip(label: symptom),
              ],
            ),
        ],
      ),
    );
  }
}

class _SymptomChip extends StatelessWidget {
  const _SymptomChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.fiber_manual_record,
            size: 7,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.sm),
          Text(
            label,
            style: AppTextStyles.scheduleMeta.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}