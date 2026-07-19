import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../home/presentation/widgets/home_top_bar.dart';
import '../manager/patient_filter/patient_filter_cubit.dart';
import '../manager/patient_filter/patient_filter_state.dart';
import '../models/assigned_patient.dart';
import '../widgets/patient_list_view.dart';
import '../widgets/patient_status_filter_list.dart';

class AssignedPatientsPage extends StatelessWidget {
  const AssignedPatientsPage({super.key});

  // data for ui , delete when back is ready
  static const List<AssignedPatient> _patients = [
    AssignedPatient(
      patientName: 'Mohammad Ali',
      subject: 'Oral Surgery',
      procedure: 'Extraction',
      sessionNumber: 2,
      status: PatientStatus.inTreatment,
    ),
    AssignedPatient(
      patientName: 'Sara Mahmoud',
      subject: 'Periodontics',
      procedure: 'Scaling & Root Planing',
      sessionNumber: 1,
      status: PatientStatus.waitingApproval,
    ),
    AssignedPatient(
      patientName: 'Lina Yousef',
      subject: 'Endodontics',
      procedure: 'Root Canal',
      sessionNumber: 3,
      status: PatientStatus.inTreatment,
    ),
    AssignedPatient(
      patientName: 'Ahmad Khaled',
      subject: 'Operative Dentistry',
      procedure: 'Composite Filling',
      sessionNumber: 4,
      status: PatientStatus.completed,
    ),
    AssignedPatient(
      patientName: 'Omar Nabil',
      subject: 'Prosthodontics',
      procedure: 'Crown Preparation',
      sessionNumber: 1,
      status: PatientStatus.waitingApproval,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientFilterCubit>(
      create: (_) => PatientFilterCubit(patients: _patients),
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
                      onViewDetails: (_) {},
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