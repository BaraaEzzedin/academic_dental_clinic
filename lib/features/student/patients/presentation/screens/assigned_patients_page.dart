import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/theme/app_text_style.dart';
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
      create: (_) =>
          PatientFilterCubit(sl<GetAssignedPatientsUseCase>())..loadPatients(),
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
                child: HomeTopBar(studentName: 'Assigned Patients'),
              ),
              BlocBuilder<PatientFilterCubit, PatientFilterState>(
                buildWhen: (previous, current) =>
                    previous.selectedFilter != current.selectedFilter,
                builder: (context, state) {
                  return PatientStatusFilterList(
                    selected: state.selectedFilter,
                    onSelected: context.read<PatientFilterCubit>().selectFilter,
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
                      return _ErrorState(
                        message: state.errorMessage ??
                            'Failed to load patients.',
                        onRetry:
                            context.read<PatientFilterCubit>().loadPatients,
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
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: AppDimensions.lg),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}