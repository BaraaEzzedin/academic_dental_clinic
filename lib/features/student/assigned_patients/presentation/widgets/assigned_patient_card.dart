import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/view_all_button.dart';
import '../../../open_cases/presentation/widgets/subject_chip.dart';
import '../../domain/entities/assigned_patient_entity.dart';
import 'appointment_date_label.dart';
import 'chief_complaint_box.dart';

class AssignedPatientCard extends StatelessWidget {
  const AssignedPatientCard({
    super.key,
    required this.patient,
    this.onViewDetails,
  });


  static const double width = 268;
  static const double height = 195;

  final AssignedPatientEntity patient;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 5, color: AppColors.primary),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.patientName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.schedulePatientName,
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        SubjectChip(
                          subject: patient.subjectName,
                          maxWidth: width,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        ChiefComplaintBox(text: patient.chiefComplaint),
                        const SizedBox(height: AppDimensions.md,),
                        Row(
                          children: [
                            Expanded(
                              child: AppointmentDateLabel(
                                date: patient.appointmentDate,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.xs),
                            ViewAllButton(
                              label: 'View Details',
                              onPressed: onViewDetails,
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