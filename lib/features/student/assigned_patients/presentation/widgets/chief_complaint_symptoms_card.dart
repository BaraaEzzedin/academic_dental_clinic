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
  final String symptoms;

  @override
  Widget build(BuildContext context) {
    final complaint = chiefComplaint.trim();
    final symptomsText = symptoms.trim();
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Chief Complaint'),
          const SizedBox(height: AppDimensions.md),
          _TextBox(
            text: complaint,
            emptyMessage: 'No chief complaint recorded.',
          ),
          const SizedBox(height: AppDimensions.lg),
          Text('SYMPTOMS', style: AppTextStyles.caseFieldLabel),
          const SizedBox(height: AppDimensions.md),
          if (symptomsText.isEmpty)
            Text(
              'No symptoms recorded.',
              style: AppTextStyles.subtitle.copyWith(
                fontSize: 13.5,
                color: AppColors.textHint,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            _TextBox(text: symptomsText, emptyMessage: ''),
        ],
      ),
    );
  }
}

class _TextBox extends StatelessWidget {
  const _TextBox({required this.text, required this.emptyMessage});

  final String text;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final isEmpty = text.isEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Text(
        isEmpty ? emptyMessage : text,
        style: AppTextStyles.noteMessage.copyWith(
          color: isEmpty ? AppColors.textHint : AppColors.textPrimary,
        ),
      ),
    );
  }
}