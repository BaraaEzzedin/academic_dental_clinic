import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/error_retry_view.dart';
import '../../../patient_case/presentation/widgets/case_details_top_bar.dart';
import '../../domain/entities/assigned_patient_entity.dart';
import '../manager/assigned_patient_details/assigned_patient_details_cubit.dart';
import '../manager/assigned_patient_details/assigned_patient_details_state.dart';
import '../widgets/assigned_patient_details_content.dart';
import '../widgets/assigned_patient_details_shimmer.dart';

/// Details of a single assigned patient, opened via "View Details" from the
/// Assigned Patients list. Presents everything the student needs to review
/// before submitting a case-acceptance request to the supervisor.
class AssignedPatientDetailsScreen extends StatelessWidget {
  const AssignedPatientDetailsScreen({super.key, required this.patient});

  final AssignedPatientEntity patient;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AssignedPatientDetailsCubit>(
      create: (_) => AssignedPatientDetailsCubit()..load(patient),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  AppDimensions.screenHorizontalPadding,
                  AppDimensions.lg,
                  AppDimensions.screenHorizontalPadding,
                  AppDimensions.lg,
                ),
                child: CaseDetailsTopBar(title: 'Patient Details'),
              ),
              Expanded(
                child: BlocConsumer<AssignedPatientDetailsCubit,
                    AssignedPatientDetailsState>(
                  listenWhen: (previous, current) =>
                      previous.submission != current.submission,
                  listener: _onSubmissionChanged,
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const AssignedPatientDetailsShimmer();
                    }
                    if (state.hasError || state.details == null) {
                      return ErrorRetryView(
                        message: state.errorMessage ??
                            'Could not load patient details.',
                        onRetry: () =>
                            context.read<AssignedPatientDetailsCubit>().load(
                                  patient,
                                ),
                      );
                    }
                    return AssignedPatientDetailsContent(
                      details: state.details!,
                      isSubmitting: state.isSubmitting,
                      onSubmit: context
                          .read<AssignedPatientDetailsCubit>()
                          .submitAcceptanceRequest,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmissionChanged(
    BuildContext context,
    AssignedPatientDetailsState state,
  ) {
    switch (state.submission) {
      case RequestSubmission.success:
        _showSnack(
          context,
          message: 'Case acceptance request sent to your supervisor.',
          icon: Icons.check_circle_rounded,
          background: AppColors.success,
        );
        Navigator.of(context).maybePop();
      case RequestSubmission.failure:
        _showSnack(
          context,
          message: 'Could not send the request. Please try again.',
          icon: Icons.error_outline_rounded,
          background: AppColors.error,
        );
      case RequestSubmission.idle:
      case RequestSubmission.submitting:
        break;
    }
  }

  void _showSnack(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color background,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: background,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          content: Row(
            children: [
              Icon(icon, color: AppColors.white, size: 20),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.button.copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      );
  }
}