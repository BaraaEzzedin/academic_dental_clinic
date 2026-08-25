import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../../../core/widgets/error_retry_view.dart';
import '../../../patient_case/presentation/widgets/case_details_top_bar.dart';
import '../../domain/entities/assigned_patient_entity.dart';
import '../../domain/use_cases/cancel_assigned_case_use_case.dart';
import '../../domain/use_cases/get_assigned_case_details_use_case.dart';
import '../manager/assigned_patient_details/assigned_patient_details_cubit.dart';
import '../manager/assigned_patient_details/assigned_patient_details_state.dart';
import '../widgets/assigned_patient_details_content.dart';
import '../widgets/assigned_patient_details_shimmer.dart';

class AssignedPatientDetailsScreen extends StatelessWidget {
  const AssignedPatientDetailsScreen({super.key, required this.patient});

  final AssignedPatientEntity patient;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AssignedPatientDetailsCubit>(
      create: (_) => AssignedPatientDetailsCubit(
        sl<GetAssignedCaseDetailsUseCase>(),
        sl<CancelAssignedCaseUseCase>(),
      )..load(patient),
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
                      previous.cancelStatus != current.cancelStatus,
                  listener: (context, state) {
                    if (state.cancelStatus == CancelAssignedStatus.success) {
                      AppSnackBar.showSuccess(
                        context,
                        'Assigned case removed successfully.',
                      );
                      // Pop back to the Assigned Patients screen, signalling it
                      // to reload its list now the case is unassigned.
                      Navigator.of(context).pop(true);
                    } else if (state.cancelStatus ==
                        CancelAssignedStatus.error) {
                      AppSnackBar.showError(
                        context,
                        state.cancelErrorMessage ??
                            'Could not remove the assigned case.',
                      );
                    }
                  },
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
                      isCancelling: state.isCancelling,
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
}