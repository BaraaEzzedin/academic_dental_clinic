import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/error_retry_view.dart';
import '../../../patient_case/presentation/screens/case_details_screen.dart';
import '../../../patient_case/presentation/widgets/case_details_top_bar.dart';
import '../../../patient_case/presentation/widgets/progress_timeline_section.dart';
import '../../domain/entities/subject_details_entity.dart';
import '../../domain/use_cases/get_subject_details_use_case.dart';
import '../manager/subject_details/subject_details_cubit.dart';
import '../manager/subject_details/subject_details_state.dart';
import '../widgets/overall_progress_card.dart';
import '../widgets/procedure_progress_card.dart';
import '../widgets/subject_case_card.dart';
import '../widgets/subject_header_card.dart';

/// Subject Details: progress across the subject's procedures and its related
/// patient cases. Sourced from `GET /students/me/subjects/{id}`.
class SubjectDetailsScreen extends StatelessWidget {
  const SubjectDetailsScreen({super.key, required this.subjectId});

  final int subjectId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SubjectDetailsCubit>(
      create: (_) =>
          SubjectDetailsCubit(sl<GetSubjectDetailsUseCase>())..load(subjectId),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  AppDimensions.screenHorizontalPadding,
                  AppDimensions.lg,
                  AppDimensions.screenHorizontalPadding,
                  AppDimensions.lg,
                ),
                child: CaseDetailsTopBar(title: 'Subject Details'),
              ),
              Expanded(
                child: BlocBuilder<SubjectDetailsCubit, SubjectDetailsState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    if (state.hasError || state.details == null) {
                      return ErrorRetryView(
                        message: state.errorMessage ??
                            'Could not load subject details.',
                        onRetry: () => context
                            .read<SubjectDetailsCubit>()
                            .load(subjectId),
                      );
                    }
                    return _SubjectDetailsBody(details: state.details!);
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

class _SubjectDetailsBody extends StatelessWidget {
  const _SubjectDetailsBody({required this.details});

  final SubjectDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontalPadding,
        0,
        AppDimensions.screenHorizontalPadding,
        AppDimensions.xl,
      ),
      children: [
        SubjectHeaderCard(details: details),
        const SizedBox(height: AppDimensions.lg),
        OverallProgressCard(details: details),
        const SizedBox(height: AppDimensions.lg),
        const SectionTitle('Procedure Progress'),
        const SizedBox(height: AppDimensions.md),
        if (details.procedures.isEmpty)
          const _EmptyHint(
            icon: Icons.checklist_rounded,
            message: 'No procedures available.',
          )
        else
          for (var i = 0; i < details.procedures.length; i++) ...[
            if (i > 0) const SizedBox(height: AppDimensions.md),
            ProcedureProgressCard(procedure: details.procedures[i]),
          ],
        const SizedBox(height: AppDimensions.lg),
        const SectionTitle('Related Cases'),
        const SizedBox(height: AppDimensions.md),
        if (details.cases.isEmpty)
          const _EmptyHint(
            icon: Icons.folder_open_rounded,
            message: 'No cases assigned yet.',
          )
        else
          for (var i = 0; i < details.cases.length; i++) ...[
            if (i > 0) const SizedBox(height: AppDimensions.md),
            SubjectCaseCard(
              subjectCase: details.cases[i],
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      CaseDetailsScreen(caseId: details.cases[i].id),
                ),
              ),
            ),
          ],
      ],
    );
  }
}

/// Compact empty-state hint matching the app's message-box style.
class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.textHint),
          const SizedBox(width: AppDimensions.md),
          Expanded(child: Text(message, style: AppTextStyles.subtitle)),
        ],
      ),
    );
  }
}
