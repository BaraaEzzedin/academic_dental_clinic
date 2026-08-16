import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/error_retry_view.dart';
import '../../../../auth/domain/use_cases/logout_use_case.dart';
import '../../../../auth/presentation/screens/select_role.dart';
import '../../../home/presentation/manager/bottom_nav/bottom_nav_cubit.dart';
import '../../../home/presentation/manager/bottom_nav/bottom_nav_state.dart';
import '../../../home/presentation/widgets/home_top_bar.dart';
import '../../domain/entities/student_dashboard_entity.dart';
import '../../domain/use_cases/get_student_dashboard_use_case.dart';
import '../manager/student_dashboard/student_dashboard_cubit.dart';
import '../manager/student_dashboard/student_dashboard_state.dart';
import '../widgets/cases_overview_card.dart';
import '../widgets/clinical_stats_grid.dart';
import '../widgets/dashboard_identity_card.dart';
import '../widgets/dashboard_section.dart';
import '../widgets/dashboard_shimmer.dart';
import '../widgets/evaluation_performance_card.dart';
import '../widgets/overall_progress_card.dart';
import '../widgets/subject_progress_card.dart';
import '../widgets/subject_ranking_card.dart';

/// The student's Academic Progress Center — replaces the Profile tab. Focused on
/// academic and clinical progress rather than personal profile details.
class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentDashboardCubit>(
      create: (_) =>
          StudentDashboardCubit(sl<GetStudentDashboardUseCase>())..load(),
      child: BlocListener<BottomNavCubit, BottomNavState>(
        listenWhen: (previous, current) =>
            current.tab == NavTab.profile && previous.tab != current.tab,
        listener: (context, _) => context.read<StudentDashboardCubit>().load(),
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
                  child: HomeTopBar(studentName: 'My Dashboard'),
                ),
                Expanded(
                  child:
                      BlocBuilder<StudentDashboardCubit, StudentDashboardState>(
                    builder: (context, state) {
                      if (state.isLoading || state.status ==
                          StudentDashboardStatus.initial) {
                        return const DashboardShimmer();
                      }
                      if (state.hasError || state.dashboard == null) {
                        return ErrorRetryView(
                          message: state.errorMessage ??
                              'Failed to load your dashboard.',
                          onRetry:
                              context.read<StudentDashboardCubit>().load,
                        );
                      }
                      return _DashboardBody(dashboard: state.dashboard!);
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

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.dashboard});

  final StudentDashboardEntity dashboard;

  @override
  Widget build(BuildContext context) {
    final subjects = dashboard.subjects;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontalPadding,
        0,
        AppDimensions.screenHorizontalPadding,
        AppDimensions.xl,
      ),
      children: [
        // 1 — Academic identity
        DashboardIdentityCard(student: dashboard.student),
        const SizedBox(height: AppDimensions.xl),

        // 2 — Overall progress (headline)
        OverallProgressCard(stats: dashboard.stats),
        const SizedBox(height: AppDimensions.xl),

        // 3 — Clinical statistics
        const DashboardSectionTitle('Clinical Statistics'),
        const SizedBox(height: AppDimensions.lg),
        ClinicalStatsGrid(stats: dashboard.stats),
        const SizedBox(height: AppDimensions.xl),

        // 4 — Cases overview
        CasesOverviewCard(stats: dashboard.stats),
        const SizedBox(height: AppDimensions.xl),

        // 5 — Subjects progress
        if (subjects.isNotEmpty) ...[
          const DashboardSectionTitle('Subjects Progress'),
          const SizedBox(height: AppDimensions.lg),
          for (var i = 0; i < subjects.length; i++) ...[
            if (i > 0) const SizedBox(height: AppDimensions.md),
            SubjectProgressCard(subject: subjects[i]),
          ],
          const SizedBox(height: AppDimensions.xl),
        ],

        // 6 — Evaluation performance
        EvaluationPerformanceCard(evaluations: dashboard.stats.evaluations),

        // 7 — Subject completion ranking
        if (subjects.length > 1) ...[
          const SizedBox(height: AppDimensions.xl),
          SubjectRankingCard(subjects: subjects),
        ],

        const SizedBox(height: AppDimensions.xl),
        _LogoutButton(onTap: () => _logout(context)),
      ],
    );
  }

  /// Confirms, signs out (best-effort backend call + local clear), then returns
  /// to the role selection screen, clearing the navigation stack.
  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        title: const Text(
          'Log Out',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: AppTextStyles.subtitle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final navigator = Navigator.of(context, rootNavigator: true);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
    await sl<LogoutUseCase>().call();
    // Clears the loading dialog and the whole app stack in one step.
    navigator.pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const SelectRole()),
      (route) => false,
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text('Log Out'),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.cardBorder),
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
