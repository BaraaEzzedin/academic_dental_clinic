import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/date_formatter.dart';


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
            DateFormatter.toDayLabel(date),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.scheduleMeta,
          ),
        ),
      ],
    );
  }
}