import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/navigation/app_route_observer.dart';
import '../../../open_cases/presentation/screens/open_cases_page.dart';
import '../../../patients/presentation/screens/assigned_patients_page.dart';
import '../../../student_dashboard/presentation/screens/student_dashboard_screen.dart';
import '../manager/bottom_nav/bottom_nav_cubit.dart';
import '../manager/bottom_nav/bottom_nav_state.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with RouteAware {
  /// Bumped every time we (re)enter Home so its whole subtree is rebuilt and
  /// each section reloads its data. Drives the Home page's [ValueKey].
  int _homeReloadTick = 0;

  static const int _homeIndex = 0;

  void _reloadHome() => setState(() => _homeReloadTick++);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  /// A pushed route on top of MainScreen was popped and we're visible again.
  @override
  void didPopNext() => _reloadHome();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BottomNavCubit>(
      create: (_) => BottomNavCubit(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          bottom: false,
          child: BlocConsumer<BottomNavCubit, BottomNavState>(
            listenWhen: (previous, current) => previous.index != current.index,
            listener: (context, state) {
              // Re-selecting the Home tab reloads its data.
              if (state.index == _homeIndex) _reloadHome();
            },
            buildWhen: (previous, current) => previous.index != current.index,
            builder: (context, state) {
              return IndexedStack(
                index: state.index,
                children: [
                  KeyedSubtree(
                    key: ValueKey<int>(_homeReloadTick),
                    child: const HomeScreen(),
                  ),
                  const OpenCasesPage(),
                  const AssignedPatientsPage(),
                  const StudentDashboardScreen(),
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
