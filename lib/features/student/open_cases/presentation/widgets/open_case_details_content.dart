import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/app_primary_button.dart';
import '../../domain/entities/open_case_details_entity.dart';
import 'medical_info_card.dart';
import 'open_case_chief_complaint_card.dart';
import 'open_case_media_card.dart';
import 'open_case_patient_card.dart';


class OpenCaseDetailsContent extends StatelessWidget {
  const OpenCaseDetailsContent({
    super.key,
    required this.details,
    required this.onStartExamination,
  });

  final OpenCaseDetailsEntity details;
  final VoidCallback onStartExamination;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontalPadding,
        0,
        AppDimensions.screenHorizontalPadding,
        AppDimensions.xl,
      ),
      children: [
        OpenCasePatientCard(details: details),
        const SizedBox(height: AppDimensions.lg),
        OpenCaseChiefComplaintCard(complaint: details.chiefComplaint),
        const SizedBox(height: AppDimensions.lg),
        MedicalInfoCard(
          title: 'Symptoms',
          icon: Icons.sick_outlined,
          accent: AppColors.secondary,
          items: details.symptoms,
          emptyMessage: 'No symptoms recorded.',
        ),
        const SizedBox(height: AppDimensions.lg),
        MedicalInfoCard(
          title: 'Current Medications',
          icon: Icons.medication_outlined,
          accent: AppColors.primary,
          items: details.currentMedications,
          emptyMessage: 'No current medications.',
        ),
        const SizedBox(height: AppDimensions.lg),
        MedicalInfoCard(
          title: 'Allergies',
          icon: Icons.warning_amber_rounded,
          accent: AppColors.warning,
          items: details.allergies,
          emptyMessage: 'No known allergies.',
        ),
        const SizedBox(height: AppDimensions.lg),
        OpenCaseMediaCard(media: details.media),
        const SizedBox(height: AppDimensions.xl),
        AppPrimaryButton(
          label: 'Initial Patient Examination',
          onPressed: onStartExamination,
          trailingIcon: Icons.arrow_forward_rounded,
        ),
      ],
    );
  }
}