import 'package:academic_dental_clinic/core/constants/app_colors.dart';
import 'package:academic_dental_clinic/features/student/add_patient/presentation/screens/add_patient_screen.dart';
import 'package:academic_dental_clinic/features/student/ai_analysis/presentation/screens/ai_analysis_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/widgets/app_primary_button.dart';
import '../../../../auth/data/data_source/auth_local_data_source.dart';
import '../../../assigned_patients/presentation/widgets/assigned_patients_section.dart';
import '../../../clinical_courses/presentation/widgets/clinical_courses_section.dart';
import '../../../today_appointments/presentation/widgets/today_schedule_section.dart';
import '../manager/student_info/student_info_cubit.dart';
import '../models/student_info.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/student_header_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontalPadding,
            vertical: AppDimensions.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeTopBar(studentName: 'Student name'),
              const SizedBox(height: AppDimensions.xl),
              BlocProvider<StudentInfoCubit>(
                create: (_) =>
                    StudentInfoCubit(sl<AuthLocalDataSource>())..load(),
                child: BlocBuilder<StudentInfoCubit, StudentInfo>(
                  builder: (context, info) => StudentHeaderCard(info: info),
                ),
              ),
              const SizedBox(height: AppDimensions.xl),
              const TodayScheduleSection(),
              const SizedBox(height: AppDimensions.xl),
              const ClinicalCoursesSection(),
              const SizedBox(height: AppDimensions.xl),
              const AssignedPatientsSection(),
              const SizedBox(height: AppDimensions.xl),
              AppPrimaryButton(
                label: 'Add your Patient',
                trailingIcon: Icons.person_add_alt_1_rounded,
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) =>
                              AddPatientScreen(),),);
                },
              ),
              const SizedBox(height: AppDimensions.md),
              AppPrimaryButton(
                label: 'AI Assistant',
                trailingIcon: Icons.auto_awesome_rounded,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AiAnalysisScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}