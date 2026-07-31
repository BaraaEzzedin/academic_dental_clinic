import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../home/presentation/widgets/home_top_bar.dart';
import '../../../patient_case/presentation/screens/case_details_screen.dart';
import '../manager/patient_filter/patient_filter_cubit.dart';
import '../manager/patient_filter/patient_filter_state.dart';
import '../widgets/patient_list_view.dart';
import '../widgets/patient_status_filter_list.dart';

class AssignedPatientsPage extends StatelessWidget {
  const AssignedPatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientFilterCubit>(
      // TODO(backend): feed patients from GetAssignedPatientsUseCase once the
      // repository/data source are wired.
      create: (_) => PatientFilterCubit(),
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
                    return PatientListView(
                      patients: state.filteredPatients,
                      onViewDetails: (patient) {
                        // TODO(backend): pass a real patient id once available.
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => CaseDetailsScreen(
                              patientId: patient.patientName,
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