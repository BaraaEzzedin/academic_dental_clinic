import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/enums/patient_status.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/status_badge.dart';
import '../../domain/entities/case_info_entity.dart';
import 'case_info_field.dart';

class PatientCaseHeaderCard extends StatelessWidget {
  const PatientCaseHeaderCard({
    super.key,
    required this.caseInfo,
    required this.status,
  });

  final CaseInfoEntity caseInfo;
  final PatientStatus status;

  @override
  Widget build(BuildContext context) {
    final accent = status.color;
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
              Container(width: 5, color: accent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  caseInfo.patientName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.casePatientName,
                                ),
                                const SizedBox(height: AppDimensions.xs),
                                Text(
                                  'ID: ${caseInfo.patientId}',
                                  style: AppTextStyles.casePatientId,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppDimensions.sm),
                          StatusBadge(status: status),
                        ],
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: AppDimensions.md),
                        child: Divider(height: 1, color: AppColors.dividerLine),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CaseInfoField(
                              label: 'Subject',
                              value: caseInfo.subjectName,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.xl),
                          Expanded(
                            child: CaseInfoField(
                              label: 'Supervisor',
                              value: caseInfo.supervisor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.md),
                      _NextSessionField(
                        date: caseInfo.nextSessionDate,
                        time: caseInfo.nextSessionTime,
                        status: status,
                      ),
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

/// The next-session block: label, the date on its own line, and the time
/// stacked beneath it. Times are hidden when the session carries date only.
class _NextSessionField extends StatelessWidget {
  const _NextSessionField({
    required this.date,
    required this.time,
    required this.status,
  });

  final String date;
  final String time;
  final PatientStatus status;

  @override
  Widget build(BuildContext context) {
    // Completed and final-review cases have no upcoming session; show the
    // status instead.
    if (status == PatientStatus.completed ||
        status == PatientStatus.finalReview) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('NEXT SESSION', style: AppTextStyles.caseFieldLabel),
          const SizedBox(height: AppDimensions.xs),
          Text(
            'No next session , the case is ${status.label}',
            style: AppTextStyles.caseFieldValue,
          ),
        ],
      );
    }

    // In treatment but nothing booked yet: no session has been scheduled.
    if (status == PatientStatus.inTreatment && date.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('NEXT SESSION', style: AppTextStyles.caseFieldLabel),
          const SizedBox(height: AppDimensions.xs),
          Text(
            'The next session has not been scheduled yet.',
            style: AppTextStyles.caseFieldValue,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('NEXT SESSION', style: AppTextStyles.caseFieldLabel),
        const SizedBox(height: AppDimensions.xs),
        Text(
          date.isEmpty ? '—' : date,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caseFieldValue,
        ),
        if (time.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.xs),
          Text(
            time,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caseFieldValue,
          ),
        ],
      ],
    );
  }
}