import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/app_primary_button.dart';
import '../../../case_acceptance_request/presentation/models/case_acceptance_request_args.dart';
import '../../../case_acceptance_request/presentation/navigation/open_case_acceptance_request.dart';
import '../../domain/entities/assigned_patient_details_entity.dart';
import 'assigned_patient_info_card.dart';
import 'chief_complaint_symptoms_card.dart';
import 'medical_information_card.dart';

class AssignedPatientDetailsContent extends StatelessWidget {
  const AssignedPatientDetailsContent({super.key, required this.details});

  final AssignedPatientDetailsEntity details;

  void _requestCaseAcceptance(BuildContext context) {
    openCaseAcceptanceRequest(
      context,
      CaseAcceptanceRequestArgs(
        patientId: details.id,
        patientName: details.patientName,
        age: details.age,
        subjectId: details.subjectId,
        subjectName: details.subjectName,
        chiefComplaint: details.chiefComplaint,
      ),
    );
  }

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
          label: 'Request Case Acceptance',
          onPressed: () => _requestCaseAcceptance(context),
          trailingIcon: Icons.arrow_forward_rounded,
        ),
      ],
    );
  }
}