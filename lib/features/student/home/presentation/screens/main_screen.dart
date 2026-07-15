import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../manager/bottom_nav/bottom_nav_cubit.dart';
import '../manager/bottom_nav/bottom_nav_state.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_Screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const List<Widget> pages = [
    HomeScreen(),
    TabPlaceholder(label: 'Patients'),
    TabPlaceholder(label: 'Patients'),
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
            builder: (context, state) {
              return IndexedStack(
                index: state.index,
                children: const [
                  TabPlaceholder(label: 'Home'),
                  TabPlaceholder(label: 'Schedule'),
                  TabPlaceholder(label: 'Patients'),
                  TabPlaceholder(label: 'Profile'),
                ],
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
  const TabPlaceholder({required this.label});

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