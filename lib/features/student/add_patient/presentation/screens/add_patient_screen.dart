import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/app_primary_button.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../../../core/widgets/app_stepper.dart';
import '../../../../auth/data/data_source/auth_local_data_source.dart';
import '../../../case_acceptance_request/domain/use_cases/get_subject_configuration_use_case.dart';
import '../../../clinical_courses/domain/use_cases/get_clinical_courses_use_case.dart';
import '../../../open_case_appointment/domain/use_cases/get_available_appointments_use_case.dart';
import '../../../patient_case/presentation/widgets/case_details_top_bar.dart';
import '../../domain/use_cases/create_walk_in_case_use_case.dart';
import '../manager/add_patient/add_patient_cubit.dart';
import '../manager/add_patient/add_patient_state.dart';
import '../widgets/patient_created_dialog.dart';
import '../widgets/step1_patient_info.dart';
import '../widgets/step2_case_info.dart';
import '../widgets/step3_appointment.dart';

class AddPatientScreen extends StatelessWidget {
  const AddPatientScreen({super.key});

  static const List<String> _steps = [
    'Patient Info',
    'Case Info',
    'Appointment',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddPatientCubit>(
      create: (_) => AddPatientCubit(
        getSubjects: sl<GetClinicalCoursesUseCase>(),
        getSubjectConfiguration: sl<GetSubjectConfigurationUseCase>(),
        getAvailableAppointments: sl<GetAvailableAppointmentsUseCase>(),
        createWalkInCase: sl<CreateWalkInCaseUseCase>(),
      ),
      child: const _AddPatientView(steps: _steps),
    );
  }
}

class _AddPatientView extends StatelessWidget {
  const _AddPatientView({required this.steps});

  final List<String> steps;

  void _onStateChanged(BuildContext context, AddPatientState state) {
    // Load subjects the first time the student reaches Step 2.
    if (state.currentStep == 1 &&
        state.subjectsStatus == SubjectsStatus.initial) {
      context.read<AddPatientCubit>().loadSubjects();
    }
    switch (state.submission) {
      case WalkInSubmission.success:
        _onCreated(context, state);
      case WalkInSubmission.failure:
        AppSnackBar.showError(
          context,
          state.submissionError ??
              'Failed to create patient. Please try again.',
        );
      case WalkInSubmission.idle:
      case WalkInSubmission.submitting:
        break;
    }
  }

  Future<void> _onCreated(BuildContext context, AddPatientState state) async {
    String studentName = '';
    try {
      studentName = await sl<AuthLocalDataSource>().getUserName() ?? '';
    } catch (_) {
      // Fall back to no student row if the name can't be read.
    }
    if (!context.mounted || state.selectedDate == null) return;
    await showPatientCreatedDialog(
      context,
      date: state.selectedDate!,
      time: state.selectedTime ?? '',
      studentName: studentName,
    );
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocConsumer<AddPatientCubit, AddPatientState>(
          listenWhen: (p, c) =>
              p.currentStep != c.currentStep || p.submission != c.submission,
          listener: _onStateChanged,
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(
                            AppDimensions.screenHorizontalPadding,
                            AppDimensions.lg,
                            AppDimensions.screenHorizontalPadding,
                            AppDimensions.lg,
                          ),
                          child: CaseDetailsTopBar(title: 'Add Patient'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.screenHorizontalPadding,
                            vertical: AppDimensions.sm,
                          ),
                          child: AppStepper(
                            currentStep: state.currentStep,
                            titles: steps,
                          ),
                        ),
                        _StepBody(step: state.currentStep),
                      ],
                    ),
                  ),
                ),
                _Footer(state: state),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StepBody extends StatelessWidget {
  const _StepBody({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case 0:
        return const Step1PatientInfo();
      case 1:
        return const Step2CaseInfo();
      default:
        return const Step3Appointment();
    }
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state});

  final AddPatientState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddPatientCubit>();
    final isLastStep = state.currentStep == 2;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.dividerLine)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontalPadding,
        AppDimensions.lg,
        AppDimensions.screenHorizontalPadding,
        AppDimensions.lg + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          if (state.currentStep > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: state.isSubmitting ? null : cubit.previousStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding:
                      const EdgeInsets.symmetric(vertical: AppDimensions.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  textStyle: AppTextStyles.button,
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: AppDimensions.md),
          ],
          Expanded(
            flex: 2,
            child: isLastStep
                ? AppPrimaryButton(
                    label: state.isSubmitting
                        ? 'Creating…'
                        : 'Create Patient',
                    isLoading: state.isSubmitting,
                    onPressed: state.canSubmit ? cubit.submit : null,
                    trailingIcon: Icons.check_rounded,
                  )
                : AppPrimaryButton(
                    label: 'Next',
                    onPressed: state.canGoNext ? cubit.nextStep : null,
                    trailingIcon: Icons.arrow_forward_rounded,
                  ),
          ),
        ],
      ),
    );
  }
}
