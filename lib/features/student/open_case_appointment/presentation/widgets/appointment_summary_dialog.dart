import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/utils/date_formatter.dart';
import 'appointment_sheet.dart';

Future<void> showAppointmentSummaryDialog(
  BuildContext context, {
  required AppointmentResult result,
  required String patientName,
  required String subject,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => _AppointmentSummaryDialog(
      result: result,
      patientName: patientName,
      subject: subject,
    ),
  );
}

class _AppointmentSummaryDialog extends StatelessWidget {
  const _AppointmentSummaryDialog({
    required this.result,
    required this.patientName,
    required this.subject,
  });

  final AppointmentResult result;
  final String patientName;
  final String subject;

  String get _shareText => '''
${result.title} Appointment

Patient: $patientName
Subject: $subject
Date: ${DateFormatter.toMediumDate(result.date)}
Time: ${result.time}''';

  Future<void> _share(BuildContext context) async {
    // Opens the native share sheet so the summary can be sent to WhatsApp,
    // Telegram, or any other installed app.
    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        text: _shareText,
        subject: '${result.title} Appointment',
        // Required for the iPad popover; harmless elsewhere.
        sharePositionOrigin:
            box != null ? box.localToGlobal(Offset.zero) & box.size : null,
      ),
    );
    if (!context.mounted) return;
    Navigator.of(context).pop();
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
              'Appointment Booked',
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
          _SummaryRow(
            icon: Icons.medical_services_outlined,
            label: 'Type',
            value: result.title,
          ),
          _SummaryRow(
            icon: Icons.person_outline_rounded,
            label: 'Patient',
            value: patientName,
          ),
          _SummaryRow(
            icon: Icons.local_hospital_outlined,
            label: 'Subject',
            value: subject,
          ),
          _SummaryRow(
            icon: Icons.calendar_today_rounded,
            label: 'Date',
            value: DateFormatter.toMediumDate(result.date),
          ),
          _SummaryRow(
            icon: Icons.schedule_rounded,
            label: 'Time',
            value: result.time,
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
          onPressed: () => _share(context),
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
            'Share Appointment',
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