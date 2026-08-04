import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../patient_case/presentation/widgets/case_info_field.dart';
import '../../domain/entities/assigned_patient_details_entity.dart';
import 'appointment_date_label.dart';
import 'subject_badge.dart';


class AssignedPatientInfoCard extends StatelessWidget {
  const AssignedPatientInfoCard({super.key, required this.details});

  final AssignedPatientDetailsEntity details;

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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SubjectBadge(subject: details.subjectName),
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
                              label: 'Gender',
                              value: details.gender,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.md),
                      Row(
                        children: [
                          Expanded(
                            child: CaseInfoField(
                              label: 'Phone',
                              value: details.phoneNumber,
                            ),
                          ),
                          Expanded(
                            child: CaseInfoField(
                              label: 'Clinic',
                              value: details.clinic,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.lg),
                      _AppointmentHighlight(
                        date: details.appointmentDate,
                        time: details.appointmentTime,
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

class _AppointmentHighlight extends StatelessWidget {
  const _AppointmentHighlight({required this.date, required this.time});

  final DateTime date;
  final String time;

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
          Text(
            'INITIAL EXAMINATION',
            style: AppTextStyles.caseFieldLabel,
          ),
          const SizedBox(height: AppDimensions.sm),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _AppointmentItem(
                    icon: Icons.event_rounded,
                    value: formatAppointmentDate(date),
                  ),
                ),
                const VerticalDivider(
                  width: AppDimensions.lg,
                  thickness: 1,
                  color: AppColors.dividerLine,
                ),
                Expanded(
                  child: _AppointmentItem(
                    icon: Icons.schedule_rounded,
                    value: time,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentItem extends StatelessWidget {
  const _AppointmentItem({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caseHighlightValue,
          ),
        ),
      ],
    );
  }
}