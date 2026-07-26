import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/session.dart';
import '../widgets/case_details_top_bar.dart';
import '../widgets/edit_session/edit_session_sheet.dart';
import '../widgets/progress_timeline_section.dart';
import '../widgets/session/session_timeline_item.dart';
import '../widgets/session_summary/session_summary_sheet.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key, required this.sessions});

  final List<Session> sessions;

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  late final List<Session> sessions = List.of(widget.sessions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.lg),
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
                          onViewSummary: () => _viewSummary(i),
                          onEdit: () => _editSession(i),
                        ),
                  ],
                ),
              ),
            ),
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
                  // TODO(backend): open the create-session flow.
                  onPressed: () => _placeholder(context, 'Create new session'),
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
        ),
      ),
    );
  }


  Future<void> _editSession(int index) async {
    final result = await showEditSessionSheet(
      context,
      session: sessions[index],
    );
    if (result == null || !mounted) return;
    setState(() {
      sessions[index] = sessions[index].copyWith(
        status: SessionStatus.completed,
        treatmentItems: result.treatmentItems,
        note: () => result.note.isEmpty ? null : result.note,
      );
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Session completed successfully')),
      );
  }


  Future<void> _viewSummary(int index) async {
    final shared = await showSessionSummarySheet(
      context,
      session: sessions[index],
    );
    if (shared == true && mounted) _placeholder(context, 'Share summary');
  }

  void _placeholder(BuildContext context, String action) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$action — coming soon')),
      );
  }
}