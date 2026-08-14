import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/status_badge.dart';
import '../../../patients/data/mapper/patient_status_mapper.dart';
import '../../domain/entities/subject_case_entity.dart';

/// Clickable card for a patient case related to the subject. Tapping it opens
/// the case details screen.
class SubjectCaseCard extends StatelessWidget {
  const SubjectCaseCard({super.key, required this.subjectCase, this.onTap});

  final SubjectCaseEntity subjectCase;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final status = patientStatusFromApi(subjectCase.rawStatus);
    final accent = status.color;
    final sessions = subjectCase.sessionCount;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
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
                    padding: const EdgeInsets.all(AppDimensions.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                subjectCase.patientName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.schedulePatientName,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.sm),
                            StatusBadge(status: status),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          '#${subjectCase.id}',
                          style: AppTextStyles.casePatientId,
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              size: 15,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: AppDimensions.xs),
                            Text(
                              sessions == 1 ? '1 Session' : '$sessions Sessions',
                              style: AppTextStyles.scheduleMeta,
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: AppColors.textHint,
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
      ),
    );
  }
}
