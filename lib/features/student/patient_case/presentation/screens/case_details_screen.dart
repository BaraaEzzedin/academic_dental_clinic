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
import '../widgets/add_session/add_session_sheet.dart';
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
                    return CaseDetailsBody(
                      details: state.details!,
                      caseId: caseId,
                    );
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
  const CaseDetailsBody({
    super.key,
    required this.details,
    required this.caseId,
  });

  final CaseDetailsEntity details;
  final int caseId;

  @override
  Widget build(BuildContext context) {
    final caseInfo = details.caseInfo;
    final status = patientStatusFromApi(caseInfo.rawStatus);
    final isPending = status == PatientStatus.waitingApproval;
    final canEdit = status.canEditTreatment;
    final timelineExists = details.timeline.isNotEmpty;

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
        DiagnosticMediaCard(
          media: details.media,
          caseId: caseId,
          // Uploads are allowed only while the case is in treatment.
          canUpload: canEdit,
        ),
        ..._sessionsRegion(context, status, timelineExists),
        if (!isPending) ...[
          const SizedBox(height: AppDimensions.lg),
          SupervisorNotesCard(notes: details.supervisorNotes),
        ],
      ],
    );
  }

  /// The timeline / sessions area, driven by the case status:
  /// - in treatment with no timeline yet → empty state + "Add Session"
  /// - any status that has timeline data → read-only timeline; the
  ///   "View Sessions" action only appears while in treatment
  /// - otherwise nothing (pending review with no data, etc.)
  List<Widget> _sessionsRegion(
    BuildContext context,
    PatientStatus status,
    bool timelineExists,
  ) {
    if (status == PatientStatus.inTreatment && !timelineExists) {
      return [
        const SizedBox(height: AppDimensions.lg),
        NoSessionsCard(onAddSession: () => _addSession(context)),
      ];
    }
    if (timelineExists) {
      return [
        const SizedBox(height: AppDimensions.lg),
        ProgressTimelineCard(
          timeline: details.timeline,
          // "View Sessions" is available in every status except pending review
          // (in treatment it edits; completed/final review it's read-only).
          onViewSessions: status == PatientStatus.waitingApproval
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SessionsScreen(
                        clinicalCaseId: caseId,
                        subjectId: details.caseInfo.subjectId,
                        // Creating sessions is allowed only while in treatment.
                        canCreateSession:
                            status == PatientStatus.inTreatment,
                      ),
                    ),
                  );
                },
        ),
      ];
    }
    return const [];
  }

  /// Opens the "Add New Session" sheet for the in-treatment case. The empty
  /// state only shows while no sessions exist, so this always creates the first
  /// session (title only). Refreshes the case details on success so the new
  /// session appears in the timeline.
  Future<void> _addSession(BuildContext context) async {
    final cubit = context.read<CaseDetailsCubit>();
    final result = await showAddSessionSheet(
      context,
      clinicalCaseId: caseId,
      subjectId: details.caseInfo.subjectId,
      isFirstSession: details.timeline.isEmpty,
    );
    if (result == null || !context.mounted) return;
    await cubit.load(caseId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Session added')),
      );
  }
}

/// Empty-state card shown while a case is in treatment but has no sessions yet.
/// [onAddSession] currently wires only the navigation/callback scaffolding.
class NoSessionsCard extends StatelessWidget {
  const NoSessionsCard({super.key, required this.onAddSession});

  final VoidCallback onAddSession;

  @override
  Widget build(BuildContext context) {
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: const Icon(
                  Icons.event_note_rounded,
                  color: AppColors.primary,
                  size: AppDimensions.iconSize,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('No sessions yet',
                        style: AppTextStyles.sectionTitle),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      'No sessions have been created yet. Add the first '
                      'treatment session to start tracking progress.',
                      style: AppTextStyles.subtitle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.lg),
          ElevatedButton.icon(
            onPressed: onAddSession,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add Session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              textStyle: AppTextStyles.button,
            ),
          ),
        ],
      ),
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
