import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/widgets/error_retry_view.dart';
import '../../../patient_case/presentation/widgets/case_details_top_bar.dart';
import '../../domain/use_cases/get_assigned_cases_use_case.dart';
import '../manager/assigned_patients/assigned_patients_cubit.dart';
import '../manager/assigned_patients/assigned_patients_state.dart';
import '../navigation/open_patient_case.dart';
import '../widgets/assigned_patients_list_shimmer.dart';
import '../widgets/assigned_patients_list_view.dart';

class AssignedPatientsScreen extends StatelessWidget {
  const AssignedPatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AssignedPatientsCubit>(
      create: (_) => AssignedPatientsCubit(sl<GetAssignedCasesUseCase>())
        ..loadAssignedPatients(),
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
                child: CaseDetailsTopBar(title: 'Assigned Patients'),
              ),
              Expanded(
                child: BlocBuilder<AssignedPatientsCubit, AssignedPatientsState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const AssignedPatientsListShimmer();
                    }
                    if (state.hasError) {
                      return ErrorRetryView(
                        message: state.errorMessage ??
                            'Failed to load assigned patients.',
                        onRetry: context
                            .read<AssignedPatientsCubit>()
                            .loadAssignedPatients,
                      );
                    }
                    return AssignedPatientsListView(
                      patients: state.patients,
                      onViewDetails: (patient) =>
                          openAssignedPatientCase(context, patient),
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