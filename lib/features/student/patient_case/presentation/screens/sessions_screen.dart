import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/service_locator/auth_service.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/error_retry_view.dart';
import '../../domain/use_cases/get_treatment_sessions_use_case.dart';
import '../../domain/use_cases/start_treatment_session_use_case.dart';
import '../manager/sessions/sessions_cubit.dart';
import '../manager/sessions/sessions_state.dart';
import '../models/session.dart';
import '../widgets/add_session/add_session_sheet.dart';
import '../widgets/case_details_top_bar.dart';
import '../widgets/edit_schedule/edit_schedule_sheet.dart';
import '../widgets/edit_session/edit_session_sheet.dart';
import '../widgets/progress_timeline_section.dart';
import '../widgets/session/session_timeline_item.dart';
import '../widgets/session/sessions_shimmer.dart';
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
      create: (_) => SessionsCubit(
        sl<GetTreatmentSessionsUseCase>(),
        sl<StartTreatmentSessionUseCase>(),
      )..load(clinicalCaseId),
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
                      return const SessionsShimmer();
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
                      // Status-driven actions: completed → view its summary;
                      // active → edit; upcoming → start. Edit/Start are
                      // placeholders until their backends are wired up.
                      onViewSummary: sessions[i].status ==
                              SessionStatus.completed
                          ? () => _viewSummary(context, sessions[i])
                          : null,
                      onEdit: sessions[i].status == SessionStatus.active
                          ? () => _editSession(context, sessions[i])
                          : null,
                      onStart: sessions[i].status == SessionStatus.upcoming
                          ? () => _startSession(context, sessions[i])
                          : null,
                      onEditSchedule: sessions[i].status ==
                              SessionStatus.upcoming
                          ? () => _editSchedule(context, sessions[i])
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
                label: Text(
                  sessions.isEmpty ? 'Add First Session' : 'Add Session',
                ),
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

  Future<void> _editSchedule(BuildContext context, Session session) async {
    final cubit = context.read<SessionsCubit>();
    final updated = await showEditScheduleSheet(
      context,
      session: session,
      subjectId: subjectId,
    );
    if (updated != true || !context.mounted) return;
    // Confirm first, then reload (shows the sessions shimmer).
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Session updated successfully')),
      );
    await cubit.load(clinicalCaseId);
  }

  Future<void> _editSession(BuildContext context, Session session) async {
    final cubit = context.read<SessionsCubit>();
    final completed = await showEditSessionSheet(
      context,
      session: session,
      subjectId: subjectId,
    );
    if (completed != true || !context.mounted) return;
    // Confirm first, then refresh so its status/timeline update.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Session completed successfully')),
      );
    await cubit.load(clinicalCaseId);
  }

  Future<void> _viewSummary(BuildContext context, Session session) {
    return showSessionSummarySheet(context, session: session);
  }

  Future<void> _addSession(BuildContext context) async {
    // A new session can only be created once every existing session is
    // completed. This is order-independent and equivalent to "the latest
    // session is completed" given the sequential lifecycle.
    final canCreate = sessions.isEmpty ||
        sessions.every((s) => s.status == SessionStatus.completed);
    if (!canCreate) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
            content: Text(
              'You must complete the current session before creating a new one.',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        );
      return;
    }

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

  Future<void> _startSession(BuildContext context, Session session) async {
    final cubit = context.read<SessionsCubit>();
    final error = await cubit.startSession(session.id);
    if (!context.mounted) return;
    if (error != null) {
      // Failure (e.g. 409 window message) — surface the backend message.
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
            content: Text(
              error,
              style: const TextStyle(color: AppColors.white),
            ),
          ),
        );
      return;
    }
    // Confirm first, then reload (shows the sessions shimmer).
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Session started successfully')),
      );
    await cubit.load(clinicalCaseId);
  }
}