import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/status_badge.dart';
import '../models/case_details.dart';
import 'case_info_field.dart';

class PatientCaseHeaderCard extends StatelessWidget {
  const PatientCaseHeaderCard({super.key, required this.details});

  final CaseDetails details;

  @override
  Widget build(BuildContext context) {
    final accent = details.status.color;
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
                                  details.patientName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.casePatientName,
                                ),
                                const SizedBox(height: AppDimensions.xs),
                                Text(
                                  'ID: ${details.patientId}',
                                  style: AppTextStyles.casePatientId,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppDimensions.sm),
                          StatusBadge(status: details.status),
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
                              value: '${details.age}',
                            ),
                          ),
                          Expanded(
                            child: CaseInfoField(
                              label: 'Next Session',
                              value: details.nextSession,
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
                              value: details.subject,
                            ),
                          ),
                          Expanded(
                            child: CaseInfoField(
                              label: 'Supervisor',
                              value: details.supervisor,
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