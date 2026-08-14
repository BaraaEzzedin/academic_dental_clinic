import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/error_retry_view.dart';
import '../../domain/use_cases/get_treatment_sessions_use_case.dart';
import '../manager/sessions/sessions_cubit.dart';
import '../manager/sessions/sessions_state.dart';
import '../models/session.dart';
import '../widgets/add_session/add_session_sheet.dart';
import '../widgets/case_details_top_bar.dart';
import '../widgets/progress_timeline_section.dart';
import '../widgets/session/session_timeline_item.dart';
import '../widgets/session_summary/session_summary_sheet.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({
    super.key,
    required this.clinicalCaseId,
    required this.subjectId,
    this.canCreateSession = false,
  });

  final int clinicalCaseId;

  /// Availability for new sessions is queried per subject.
  final int subjectId;

  /// Whether the "Create New Session" action is shown. Hidden in read-only
  /// states (completed / final review); only enabled while in treatment.
  final bool canCreateSession;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SessionsCubit>(
      create: (_) => SessionsCubit(sl<GetTreatmentSessionsUseCase>())
        ..load(clinicalCaseId),
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
                child: CaseDetailsTopBar(title: 'Treatment Sessions'),
              ),
              Expanded(
                child: BlocBuilder<SessionsCubit, SessionsState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    if (state.hasError) {
                      return ErrorRetryView(
                        message:
                            state.errorMessage ?? 'Could not load sessions.',
                        onRetry: () => context
                            .read<SessionsCubit>()
                            .load(clinicalCaseId),
                      );
                    }
                    return _SessionsBody(
                      sessions: state.sessions,
                      canCreateSession: canCreateSession,
                      clinicalCaseId: clinicalCaseId,
                      subjectId: subjectId,
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

class _SessionsBody extends StatelessWidget {
  const _SessionsBody({
    required this.sessions,
    required this.canCreateSession,
    required this.clinicalCaseId,
    required this.subjectId,
  });

  final List<Session> sessions;
  final bool canCreateSession;
  final int clinicalCaseId;
  final int subjectId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.screenHorizontalPadding,
              0,
              AppDimensions.screenHorizontalPadding,
              AppDimensions.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Sessions',
                    style: AppTextStyles.sessionsHeading),
                const SizedBox(height: AppDimensions.lg),
                if (sessions.isEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppDimensions.lg),
                    child: Text(
                      'No sessions recorded yet.',
                      style: AppTextStyles.subtitle,
                    ),
                  )
                else
                  for (var i = 0; i < sessions.length; i++)
                    SessionTimelineItem(
                      session: sessions[i],
                      isLast: i == sessions.length - 1,
                      // Read-only: completed sessions can view their summary;
                      // editing is not available until the create/edit backend
                      // is wired up.
                      onViewSummary: sessions[i].status ==
                              SessionStatus.completed
                          ? () => _viewSummary(context, sessions[i])
                          : null,
                    ),
              ],
            ),
          ),
        ),
        if (canCreateSession)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.screenHorizontalPadding,
              AppDimensions.sm,
              AppDimensions.screenHorizontalPadding,
              AppDimensions.lg,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _addSession(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create New Session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: AppDimensions.md),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  textStyle: AppTextStyles.button,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _viewSummary(BuildContext context, Session session) async {
    final shared = await showSessionSummarySheet(context, session: session);
    if (shared == true && context.mounted) {
      _comingSoon(context, 'Share summary');
    }
  }

  Future<void> _addSession(BuildContext context) async {
    final cubit = context.read<SessionsCubit>();
    final result = await showAddSessionSheet(
      context,
      clinicalCaseId: clinicalCaseId,
      subjectId: subjectId,
      isFirstSession: sessions.isEmpty,
    );
    if (result == null || !context.mounted) return;
    // Session created — refresh the list so the new session appears.
    await cubit.load(clinicalCaseId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Session added')),
      );
  }

  void _comingSoon(BuildContext context, String action) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$action — coming soon')),
      );
  }
}