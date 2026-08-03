import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/widgets/error_retry_view.dart';
import '../../../home/presentation/manager/bottom_nav/bottom_nav_cubit.dart';
import '../../../home/presentation/manager/bottom_nav/bottom_nav_state.dart';
import '../../../home/presentation/widgets/home_top_bar.dart';
import '../../../patient_case/presentation/screens/case_details_screen.dart';
import '../../domain/use_cases/get_assigned_patients_use_case.dart';
import '../manager/patient_filter/patient_filter_cubit.dart';
import '../manager/patient_filter/patient_filter_state.dart';
import '../widgets/patient_list_shimmer.dart';
import '../widgets/patient_list_view.dart';
import '../widgets/patient_status_filter_list.dart';

class AssignedPatientsPage extends StatelessWidget {
  const AssignedPatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientFilterCubit>(
      create: (_) => PatientFilterCubit(sl<GetAssignedPatientsUseCase>()),
      child: BlocListener<BottomNavCubit, BottomNavState>(
        listenWhen: (previous, current) =>
            current.tab == NavTab.patients && previous.tab != current.tab,
        listener: (context, _) =>
            context.read<PatientFilterCubit>().loadPatients(),
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDimensions.screenHorizontalPadding,
                    AppDimensions.lg,
                    AppDimensions.screenHorizontalPadding,
                    AppDimensions.lg,
                  ),
                  child: HomeTopBar(studentName: 'My Patients'),
                ),
                BlocBuilder<PatientFilterCubit, PatientFilterState>(
                  buildWhen: (previous, current) =>
                      previous.selectedFilter != current.selectedFilter,
                  builder: (context, state) {
                    return PatientStatusFilterList(
                      selected: state.selectedFilter,
                      onSelected: context
                          .read<PatientFilterCubit>()
                          .selectFilter,
                    );
                  },
                ),
                Expanded(
                  child: BlocBuilder<PatientFilterCubit, PatientFilterState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const PatientListShimmer();
                      }
                      if (state.hasError) {
                        return ErrorRetryView(
                          message:
                              state.errorMessage ?? 'Failed to load patients.',
                          onRetry: context
                              .read<PatientFilterCubit>()
                              .loadPatients,
                        );
                      }
                      return PatientListView(
                        patients: state.filteredPatients,
                        onViewDetails: (patient) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => CaseDetailsScreen(
                                patientId: patient.id.toString(),
                                status: patient.status,
                              ),
                            ),
                          );
                        },
                      );
                    },
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
