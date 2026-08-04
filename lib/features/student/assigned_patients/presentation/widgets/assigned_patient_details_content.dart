import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/app_primary_button.dart';
import '../../domain/entities/assigned_patient_details_entity.dart';
import 'assigned_patient_info_card.dart';
import 'chief_complaint_symptoms_card.dart';
import 'medical_information_card.dart';

class AssignedPatientDetailsContent extends StatelessWidget {
  const AssignedPatientDetailsContent({
    super.key,
    required this.details,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final AssignedPatientDetailsEntity details;
  final bool isSubmitting;
  final VoidCallback onSubmit;

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
        AssignedPatientInfoCard(details: details),
        const SizedBox(height: AppDimensions.lg),
        ChiefComplaintSymptomsCard(
          chiefComplaint: details.chiefComplaint,
          symptoms: details.symptoms,
        ),
        const SizedBox(height: AppDimensions.lg),
        MedicalInformationCard(
          currentMedications: details.currentMedications,
          medicalConditions: details.medicalConditions,
          allergies: details.allergies,
        ),
        const SizedBox(height: AppDimensions.xl),
        AppPrimaryButton(
          label: isSubmitting
              ? 'Submitting…'
              : 'Submit Case Acceptance Request',
          onPressed: isSubmitting ? null : onSubmit,
          trailingIcon: isSubmitting ? null : Icons.send_rounded,
        ),
      ],
    );
  }
}