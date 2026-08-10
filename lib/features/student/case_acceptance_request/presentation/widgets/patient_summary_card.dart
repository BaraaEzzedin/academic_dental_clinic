import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../assigned_patients/presentation/widgets/subject_badge.dart';
import '../models/case_acceptance_request_args.dart';

class PatientSummaryCard extends StatelessWidget {
  const PatientSummaryCard({super.key, required this.args});

  final CaseAcceptanceRequestArgs args;

  @override
  Widget build(BuildContext context) {
    final complaint = args.chiefComplaint.trim();
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 5, color: AppColors.primary),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        args.patientName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.casePatientName,
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SubjectBadge(subject: args.subjectName),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: AppDimensions.md),
                        child: Divider(height: 1, color: AppColors.dividerLine),
                      ),
                      _ChiefComplaint(complaint: complaint),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChiefComplaint extends StatelessWidget {
  const _ChiefComplaint({required this.complaint});

  final String complaint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CHIEF COMPLAINT', style: AppTextStyles.caseFieldLabel),
          const SizedBox(height: AppDimensions.sm),
          Text(
            complaint.isEmpty ? 'No chief complaint recorded.' : complaint,
            style: AppTextStyles.noteMessage.copyWith(
              color:
                  complaint.isEmpty ? AppColors.textHint : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}