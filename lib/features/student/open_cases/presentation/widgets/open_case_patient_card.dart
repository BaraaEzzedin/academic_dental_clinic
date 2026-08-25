import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../patient_case/presentation/widgets/case_info_field.dart';
import '../../domain/entities/open_case_details_entity.dart';
import 'subject_chip.dart';

class OpenCasePatientCard extends StatelessWidget {
  const OpenCasePatientCard({super.key, required this.details});

  final OpenCaseDetailsEntity details;

  @override
  Widget build(BuildContext context) {
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
                        details.patientName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.casePatientName,
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      SubjectChip(subject: details.subject),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: AppDimensions.md),
                        child: Divider(height: 1, color: AppColors.dividerLine),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CaseInfoField(
                              label: 'Date of Birth',
                              value: details.dateOfBirth,
                            ),
                          ),
                          Expanded(
                            child: CaseInfoField(
                              label: 'Gender',
                              value: details.gender,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.md),
                      CaseInfoField(
                        label: 'Mobile',
                        value: details.phoneNumber,
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