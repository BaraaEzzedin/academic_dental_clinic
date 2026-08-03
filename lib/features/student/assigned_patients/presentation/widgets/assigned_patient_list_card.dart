import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/view_details_button.dart';
import '../../domain/entities/assigned_patient_entity.dart';
import 'appointment_date_label.dart';
import 'chief_complaint_box.dart';
import 'subject_badge.dart';


class AssignedPatientListCard extends StatelessWidget {
  const AssignedPatientListCard({
    super.key,
    required this.patient,
    this.onViewDetails,
  });

  final AssignedPatientEntity patient;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onViewDetails,
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                patient.patientName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.schedulePatientName,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.sm),
                            SubjectBadge(
                              subject: patient.subjectName,
                              maxWidth: 150,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.md),
                        ChiefComplaintBox(
                          text: patient.chiefComplaint,
                          maxLines: 3,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        Row(
                          children: [
                            Expanded(
                              child: AppointmentDateLabel(
                                date: patient.appointmentDate,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.md),
                        ViewDetailsButton(onPressed: onViewDetails),
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