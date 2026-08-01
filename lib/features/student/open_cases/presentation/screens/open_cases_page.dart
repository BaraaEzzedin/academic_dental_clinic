import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/widgets/error_retry_view.dart';
import '../../../home/presentation/manager/bottom_nav/bottom_nav_cubit.dart';
import '../../../home/presentation/manager/bottom_nav/bottom_nav_state.dart';
import '../../../home/presentation/widgets/home_top_bar.dart';
import '../manager/open_cases/open_cases_cubit.dart';
import '../manager/open_cases/open_cases_state.dart';
import '../widgets/open_case_list_shimmer.dart';
import '../widgets/open_case_list_view.dart';
import '../widgets/subject_filter_list.dart';

class OpenCasesPage extends StatelessWidget {
  const OpenCasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OpenCasesCubit>(
      create: (_) => OpenCasesCubit()..loadCases(),
      child: BlocListener<BottomNavCubit, BottomNavState>(
        listenWhen: (previous, current) =>
            current.tab == NavTab.openCases && previous.tab != current.tab,
        listener: (context, _) => context.read<OpenCasesCubit>().loadCases(),
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
                  child: HomeTopBar(studentName: 'Patient Requests'),
                ),
                BlocBuilder<OpenCasesCubit, OpenCasesState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status ||
                      previous.subjects != current.subjects ||
                      previous.selectedSubjectId != current.selectedSubjectId,
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const SubjectFilterShimmer();
                    }
                    if (state.subjects.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return SubjectFilterList(
                      subjects: state.subjects,
                      selectedId: state.selectedSubjectId,
                      onSelected: context.read<OpenCasesCubit>().selectSubject,
                    );
                  },
                ),
                Expanded(
                  child: BlocBuilder<OpenCasesCubit, OpenCasesState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const OpenCaseListShimmer();
                      }
                      if (state.hasError) {
                        return ErrorRetryView(
                          message:
                              state.errorMessage ?? 'Failed to load cases.',
                          onRetry: context.read<OpenCasesCubit>().loadCases,
                        );
                      }
                      return OpenCaseListView(
                        cases: state.filteredCases,
                        onViewDetails: (openCase) {
                          // TODO(details): navigate to the case details screen
                          // once the open-case details flow is available.
                        },
                      );
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
