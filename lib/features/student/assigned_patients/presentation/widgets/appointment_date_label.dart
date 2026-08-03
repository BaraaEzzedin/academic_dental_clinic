import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';


class AppointmentDateLabel extends StatelessWidget {
  const AppointmentDateLabel({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.event_rounded,
          size: 14,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppDimensions.xs),
        Flexible(
          child: Text(
            formatAppointmentDate(date),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.scheduleMeta,
          ),
        ),
      ],
    );
  }
}

const List<String> _monthsShort = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

const List<String> _weekdaysShort = [
  'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
];

/// e.g. "Wed, Aug 5"
String formatAppointmentDate(DateTime date) {
  final weekday = _weekdaysShort[date.weekday - 1];
  return '$weekday, ${_monthsShort[date.month - 1]} ${date.day}';
}