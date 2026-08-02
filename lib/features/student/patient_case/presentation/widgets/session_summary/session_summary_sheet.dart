import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/widgets/sheet_grabber.dart';
import '../../models/session.dart';
import 'session_summary_footer.dart';
import 'session_summary_header.dart';
import 'session_summary_note.dart';
import 'summary_item_card.dart';


Future<bool?> showSessionSummarySheet(
  BuildContext context, {
  required Session session,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SessionSummarySheet(session: session),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (session.treatmentItems.isNotEmpty) ...[
                    const _SectionHeader(
                      icon: Icons.checklist_rounded,
                      title: 'Treatment Items',
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    for (var i = 0;
                        i < session.treatmentItems.length;
                        i++)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: i == session.treatmentItems.length - 1
                              ? 0
                              : AppDimensions.lg,
                        ),
                        child: SummaryItemCard(
                          item: session.treatmentItems[i],
                        ),
                      ),
                    const SizedBox(height: AppDimensions.xl),
                  ],
                  const _SectionHeader(
                    icon: Icons.notes_rounded,
                    title: 'Clinical Notes',
                  ),
                  const SizedBox(height: AppDimensions.md),
                  SessionSummaryNote(note: session.note),
                ],
              ),
            ),
          ),
          SessionSummaryFooter(
            onShare: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
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