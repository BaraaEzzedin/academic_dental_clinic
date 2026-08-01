import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../open_cases/presentation/screens/open_cases_page.dart';
import '../../../patients/presentation/screens/assigned_patients_page.dart';
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
    TabPlaceholder(label: 'Patients'),
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

class TabPlaceholder extends StatelessWidget {
  const TabPlaceholder({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}