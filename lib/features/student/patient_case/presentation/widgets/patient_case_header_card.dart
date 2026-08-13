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
                              label: 'Age',
                              value: '${caseInfo.patientAge}',
                            ),
                          ),
                          Expanded(
                            child: CaseInfoField(
                              label: 'Next Session',
                              value: caseInfo.nextSession,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.md),
                      Row(
                        children: [
                          Expanded(
                            child: CaseInfoField(
                              label: 'Subject',
                              value: caseInfo.subjectName,
                            ),
                          ),
                          Expanded(
                            child: CaseInfoField(
                              label: 'Supervisor',
                              value: caseInfo.supervisor,
                            ),
                          ),
                        ],
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