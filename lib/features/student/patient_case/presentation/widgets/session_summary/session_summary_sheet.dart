import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/service_locator/auth_service.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../../../../core/utils/date_formatter.dart';
import '../../../../../../core/widgets/error_retry_view.dart';
import '../../../../../../core/widgets/sheet_grabber.dart';
import '../../../domain/entities/session_summary_entity.dart';
import '../../../domain/use_cases/get_session_summary_use_case.dart';
import '../../manager/session_summary/session_summary_cubit.dart';
import '../../manager/session_summary/session_summary_state.dart';
import '../../models/session.dart';
import '../../models/session_procedure_status.dart';
import 'session_summary_footer.dart';
import 'session_summary_header.dart';
import 'session_summary_note.dart';
import 'session_summary_shimmer.dart';
import 'summary_procedure_card.dart';

Future<void> showSessionSummarySheet(
  BuildContext context, {
  required Session session,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) =>
          SessionSummaryCubit(sl<GetSessionSummaryUseCase>())..load(session.id),
      child: SessionSummarySheet(session: session),
    ),
  );
}

class SessionSummarySheet extends StatelessWidget {
  const SessionSummarySheet({super.key, required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetGrabber(),
          SessionSummaryHeader(
            title: session.title,
            date: session.date,
            onClose: () => Navigator.of(context).pop(),
          ),
          const Divider(height: 1, color: AppColors.dividerLine),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.xl),
              child: BlocBuilder<SessionSummaryCubit, SessionSummaryState>(
                builder: (context, state) => _body(context, state),
              ),
            ),
          ),
          BlocBuilder<SessionSummaryCubit, SessionSummaryState>(
            builder: (context, state) {
              final summary = state.summary;
              if (summary == null) return const SizedBox.shrink();
              return SessionSummaryFooter(
                onShare: () => _shareSummary(summary),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, SessionSummaryState state) {
    if (state.isLoading) {
      return const SessionSummaryShimmer();
    }
    if (state.hasError || state.summary == null) {
      return ErrorRetryView(
        message: state.errorMessage ?? 'Could not load the summary.',
        onRetry: () => context.read<SessionSummaryCubit>().load(session.id),
      );
    }

    final summary = state.summary!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          icon: Icons.checklist_rounded,
          title: 'Procedures',
        ),
        const SizedBox(height: AppDimensions.lg),
        if (summary.treatmentItems.isEmpty)
          Text(
            'No procedures recorded for this session.',
            style: AppTextStyles.subtitle,
          )
        else
          for (var i = 0; i < summary.treatmentItems.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == summary.treatmentItems.length - 1
                    ? 0
                    : AppDimensions.lg,
              ),
              child: SummaryProcedureCard(item: summary.treatmentItems[i]),
            ),
        const SizedBox(height: AppDimensions.xl),
        const _SectionHeader(
          icon: Icons.notes_rounded,
          title: 'Clinical Notes',
        ),
        const SizedBox(height: AppDimensions.md),
        SessionSummaryNote(note: summary.notes),
      ],
    );
  }

  /// Opens the native share sheet (WhatsApp, Instagram, …) with a text summary.
  Future<void> _shareSummary(SessionSummaryEntity summary) async {
    final buffer = StringBuffer()
      ..writeln('Session Summary')
      ..writeln(summary.title);
    if (summary.appointmentDate != null) {
      buffer.writeln(DateFormatter.toMediumDate(summary.appointmentDate!));
    }
    if (summary.treatmentItems.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('Procedures:');
      for (final item in summary.treatmentItems) {
        final label = sessionProcedureStatusFromApi(item.rawStatus).label;
        buffer.writeln(
          '- Tooth #${item.toothNumber} · ${item.procedureName} — $label',
        );
      }
    }
    if (summary.notes.trim().isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('Notes:')
        ..writeln(summary.notes.trim());
    }
    await SharePlus.instance.share(ShareParams(text: buffer.toString()));
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppDimensions.sm),
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
