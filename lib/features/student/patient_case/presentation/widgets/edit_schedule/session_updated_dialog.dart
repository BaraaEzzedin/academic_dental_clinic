import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/utils/date_formatter.dart';

/// Shown after a session's schedule is edited successfully. Summarizes the new
/// schedule and lets the student share it as text (WhatsApp/Telegram/SMS…).
Future<void> showSessionUpdatedDialog(
  BuildContext context, {
  required String title,
  required DateTime? date,
  required String time,
  required String studentName,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _SessionUpdatedDialog(
      title: title,
      date: date,
      time: time,
      studentName: studentName,
    ),
  );
}

class _SessionUpdatedDialog extends StatelessWidget {
  const _SessionUpdatedDialog({
    required this.title,
    required this.date,
    required this.time,
    required this.studentName,
  });

  final String title;
  final DateTime? date;
  final String time;
  final String studentName;

  bool get _hasTitle => title.trim().isNotEmpty;
  bool get _hasDate => date != null;
  bool get _hasTime => time.trim().isNotEmpty;
  bool get _hasStudent => studentName.trim().isNotEmpty;

  String get _shareText {
    final buffer = StringBuffer()
      ..writeln('Session schedule updated successfully.')
      ..writeln();
    if (_hasTitle) buffer.writeln('Session: ${title.trim()}');
    if (_hasDate) buffer.writeln('Date: ${DateFormatter.toMediumDate(date!)}');
    if (_hasTime) buffer.writeln('Start: $time');
    if (_hasStudent) buffer.writeln('Student: $studentName');
    return buffer.toString().trimRight();
  }

  Future<void> _share() async {
    await SharePlus.instance.share(ShareParams(text: _shareText));
  }

  @override
  Widget build(BuildContext context) {
    final rows = <_SummaryRow>[
      if (_hasTitle)
        _SummaryRow(
          icon: Icons.event_note_rounded,
          label: 'Session',
          value: title.trim(),
        ),
      if (_hasDate)
        _SummaryRow(
          icon: Icons.calendar_today_rounded,
          label: 'Date',
          value: DateFormatter.toMediumDate(date!),
        ),
      if (_hasTime)
        _SummaryRow(
          icon: Icons.schedule_rounded,
          label: 'Start',
          value: time,
        ),
      if (_hasStudent)
        _SummaryRow(
          icon: Icons.person_outline_rounded,
          label: 'Student',
          value: studentName,
        ),
    ];

    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      titlePadding: const EdgeInsets.fromLTRB(
        AppDimensions.xl,
        AppDimensions.xl,
        AppDimensions.xl,
        AppDimensions.md,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        AppDimensions.xl,
        0,
        AppDimensions.xl,
        AppDimensions.md,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppDimensions.lg,
        0,
        AppDimensions.lg,
        AppDimensions.md,
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.caseChipBackground,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          const Expanded(
            child: Text(
              'Session Updated',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'The session schedule was updated successfully.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          for (var i = 0; i < rows.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == rows.length - 1 ? 0 : AppDimensions.md,
              ),
              child: rows[i],
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.lg,
              vertical: AppDimensions.md,
            ),
          ),
          child: const Text(
            'OK',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        ElevatedButton.icon(
          onPressed: _share,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.lg,
              vertical: AppDimensions.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
          icon: const Icon(Icons.ios_share_rounded, size: 18),
          label: const Text(
            'Share',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: AppDimensions.md),
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textHint,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
