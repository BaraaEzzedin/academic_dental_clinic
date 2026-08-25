import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/app_primary_button.dart';
import '../../../case_acceptance_request/presentation/models/case_acceptance_request_args.dart';
import '../../../case_acceptance_request/presentation/navigation/open_case_acceptance_request.dart';
import '../../domain/entities/assigned_patient_details_entity.dart';
import '../manager/assigned_patient_details/assigned_patient_details_cubit.dart';
import 'assigned_patient_info_card.dart';
import 'chief_complaint_symptoms_card.dart';
import 'medical_information_card.dart';

class AssignedPatientDetailsContent extends StatelessWidget {
  const AssignedPatientDetailsContent({
    super.key,
    required this.details,
    this.isCancelling = false,
  });

  final AssignedPatientDetailsEntity details;

  /// When true the cancel request is in flight and the button shows a spinner.
  final bool isCancelling;

  void _requestCaseAcceptance(BuildContext context) {
    openCaseAcceptanceRequest(
      context,
      CaseAcceptanceRequestArgs(
        clinicalCaseId: details.id,
        patientId: details.patientId,
        patientName: details.patientName,
        subjectId: details.subjectId,
        subjectName: details.subjectName,
        chiefComplaint: details.chiefComplaint,
        supervisorName: details.assignedSupervisorName,
        section: details.clinic,
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final cubit = context.read<AssignedPatientDetailsCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        title: const Text(
          'Remove Assignment',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure to remove this assigned?',
          style: AppTextStyles.subtitle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Ignore'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Cancel Case'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await cubit.cancelAssignment(details.id);
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
          medicalHistory: details.medicalHistory,
          allergies: details.allergies,
        ),
        const SizedBox(height: AppDimensions.xl),
        AppPrimaryButton(
          label: 'Request Case Acceptance',
          onPressed: () => _requestCaseAcceptance(context),
          trailingIcon: Icons.arrow_forward_rounded,
        ),
        const SizedBox(height: AppDimensions.md),
        SizedBox(
          width: double.infinity,
          height: AppDimensions.buttonHeight,
          child: OutlinedButton(
            onPressed: isCancelling ? null : () => _confirmCancel(context),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
            ),
            child: isCancelling
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.error),
                    ),
                  )
                : Text(
                    'Cancel',
                    style: AppTextStyles.button
                        .copyWith(color: AppColors.error),
                  ),
          ),
        ),
      ],
    );
  }
}
