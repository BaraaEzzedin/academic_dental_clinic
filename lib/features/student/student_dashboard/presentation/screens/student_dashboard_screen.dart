import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/widgets/error_retry_view.dart';
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
      ],
    );
  }
}
