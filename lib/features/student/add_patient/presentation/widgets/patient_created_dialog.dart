import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/utils/date_formatter.dart';

/// Shown after a walk-in patient is created successfully. Summarizes the first
/// appointment and lets the student share it as text (WhatsApp/Telegram/SMS…).
Future<void> showPatientCreatedDialog(
  BuildContext context, {
  required DateTime date,
  required String time,
  required String studentName,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _PatientCreatedDialog(
      date: date,
      time: time,
      studentName: studentName,
    ),
  );
}

class _PatientCreatedDialog extends StatelessWidget {
  const _PatientCreatedDialog({
    required this.date,
    required this.time,
    required this.studentName,
  });

  final DateTime date;
  final String time;
  final String studentName;

  bool get _hasStudent => studentName.trim().isNotEmpty;

  String get _shareText {
    final buffer = StringBuffer()
      ..writeln('Your first appointment details:')
      ..writeln()
      ..writeln('Date: ${DateFormatter.toMediumDate(date)}')
      ..writeln('Time: $time');
    if (_hasStudent) buffer.writeln('Student: $studentName');
    return buffer.toString().trimRight();
  }

  Future<void> _share() async {
    await SharePlus.instance.share(ShareParams(text: _shareText));
  }

  @override
  Widget build(BuildContext context) {
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
              'Patient Created',
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
            'Your first appointment details:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          _SummaryRow(
            icon: Icons.calendar_today_rounded,
            label: 'Date',
            value: DateFormatter.toMediumDate(date),
          ),
          _SummaryRow(
            icon: Icons.schedule_rounded,
            label: 'Time',
            value: time,
            isLast: !_hasStudent,
          ),
          if (_hasStudent)
            _SummaryRow(
              icon: Icons.person_outline_rounded,
              label: 'Student',
              value: studentName,
              isLast: true,
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
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimensions.md),
      child: Row(
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
      ),
    );
  }
}
