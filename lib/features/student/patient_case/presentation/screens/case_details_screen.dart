import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/enums/patient_status.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../patients/data/mapper/patient_status_mapper.dart';
import '../../domain/entities/case_details_entity.dart';
import '../../domain/use_cases/get_case_details_use_case.dart';
import '../manager/case_details/case_details_cubit.dart';
import '../manager/case_details/case_details_state.dart';
import '../models/demo_sessions.dart';
import '../widgets/case_details_top_bar.dart';
import '../widgets/diagnostic_media_card.dart';
import '../widgets/patient_case_header_card.dart';
import '../widgets/progress_timeline_card.dart';
import '../widgets/progress_timeline_section.dart';
import '../widgets/supervisor_notes_card.dart';
import '../widgets/treatment_plan_summary_card.dart';
import 'dental_chart_screen.dart';
import 'sessions_screen.dart';

class CaseDetailsScreen extends StatelessWidget {
  const CaseDetailsScreen({super.key, required this.caseId});

  final int caseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CaseDetailsCubit>(
      create: (_) => CaseDetailsCubit(sl<GetCaseDetailsUseCase>())..load(caseId),
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
                child: CaseDetailsTopBar(),
              ),
              Expanded(
                child: BlocBuilder<CaseDetailsCubit, CaseDetailsState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    if (state.hasError || state.details == null) {
                      return ErrorView(
                        message: state.errorMessage ??
                            'Could not load case details.',
                        onRetry: () =>
                            context.read<CaseDetailsCubit>().load(caseId),
                      );
                    }
                    return CaseDetailsBody(details: state.details!);
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

class CaseDetailsBody extends StatelessWidget {
  const CaseDetailsBody({super.key, required this.details});

  final CaseDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    final caseInfo = details.caseInfo;
    final status = patientStatusFromApi(caseInfo.rawStatus);
    final isPending = status == PatientStatus.waitingApproval;
    final canEdit = status.canEditTreatment;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontalPadding,
        0,
        AppDimensions.screenHorizontalPadding,
        AppDimensions.xl,
      ),
      children: [
        PatientCaseHeaderCard(caseInfo: caseInfo, status: status),
        const SizedBox(height: AppDimensions.lg),
        TreatmentPlanSummaryCard(
          procedures: details.targetTeeth,
          materials: details.materials,
          requiresDentalChart: caseInfo.requiresDentalChart,
          // Dental chart is view-only and available in every status.
          onViewDentalChart: caseInfo.requiresDentalChart
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          DentalChartScreen(procedures: details.targetTeeth),
                    ),
                  );
                }
              : null,
        ),
        if (isPending) ...[
          const SizedBox(height: AppDimensions.lg),
          const ApprovalPendingCard(),
        ],
        const SizedBox(height: AppDimensions.lg),
        DiagnosticMediaCard(media: details.media),
        if (!isPending) ...[
          const SizedBox(height: AppDimensions.lg),
          ProgressTimelineCard(
            timeline: details.timeline,
            // Sessions are editable only while in treatment.
            onViewSessions: canEdit
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            SessionsScreen(sessions: demoSessions()),
                      ),
                    );
                  }
                : null,
          ),
          const SizedBox(height: AppDimensions.lg),
          SupervisorNotesCard(notes: details.supervisorNotes),
        ],
      ],
    );
  }
}

class ApprovalPendingCard extends StatelessWidget {
  const ApprovalPendingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProgressTimelineSection(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.sm),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: const Icon(
              Icons.hourglass_top_rounded,
              color: AppColors.warning,
              size: AppDimensions.iconSize,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Waiting for supervisor approval',
                    style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  'Treatment sessions, progress timeline, and supervisor notes '
                  'will appear here once the supervisor approves this case.',
                  style: AppTextStyles.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: AppDimensions.lg),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
