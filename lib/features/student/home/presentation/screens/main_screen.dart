import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../open_cases/presentation/screens/open_cases_page.dart';
import '../../../patients/presentation/screens/assigned_patients_page.dart';
import '../../../student_dashboard/presentation/screens/student_dashboard_screen.dart';
import '../manager/bottom_nav/bottom_nav_cubit.dart';
import '../manager/bottom_nav/bottom_nav_state.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const List<Widget> pages = [
    HomeScreen(),
    OpenCasesPage(),
    AssignedPatientsPage(),
    StudentDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BottomNavCubit>(
      create: (_) => BottomNavCubit(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<BottomNavCubit, BottomNavState>(
            buildWhen: (previous, current) => previous.index != current.index,
            builder: (context, state) {
              return IndexedStack(
                index: state.index,
                children: pages,
              );
            },
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(),
      ),
    );
  }
}