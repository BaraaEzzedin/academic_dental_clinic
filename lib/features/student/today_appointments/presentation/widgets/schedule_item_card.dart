import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/enums/clinical_appointment_status.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../domain/entities/today_appointment_entity.dart';
import 'appointment_card.dart';

class ScheduleItemCard extends StatelessWidget {
  const ScheduleItemCard({
    super.key,
    required this.item,
    this.isFirst = false,
    this.isLast = false,
    this.showDate = false,
    this.onTap,
  });

  final AppointmentEntity item;
  final bool isFirst;
  final bool isLast;

  /// Whether to surface the appointment's date as the third line — used for the
  /// "upcoming" group, where the day matters. Hidden for today's items.
  final bool showDate;
  final VoidCallback? onTap;

  Color get accent => switch (item.status) {
        ClinicalAppointmentStatus.scheduled => AppColors.primary,
        ClinicalAppointmentStatus.completed => AppColors.success,
        ClinicalAppointmentStatus.cancelled => AppColors.error,
        ClinicalAppointmentStatus.noShow => AppColors.warning,
      };

  String get _startTime => DateFormatter.toTimeOfDay(item.start);

  String get _subtitle {
    final supervisor = item.supervisorName.trim();
    return supervisor.isEmpty ? '' : 'Dr. $supervisor';
  }

  String get _dateLabel =>
      (showDate && item.date != null) ? DateFormatter.toMediumDate(item.date!) : '';

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TimelineGutter(
            completed: item.status == ClinicalAppointmentStatus.completed,
            isFirst: isFirst,
            isLast: isLast,
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimensions.lg),
              child: AppointmentCard(
                accent: accent,
                title: item.patientName,
                subject: _subtitle,
                time: _startTime,
                meta: _dateLabel,
                metaIcon: Icons.event_outlined,
                badgeLabel: item.status.label,
                onTap: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineGutter extends StatelessWidget {
  const TimelineGutter({
    super.key,
    required this.completed,
    required this.isFirst,
    required this.isLast,
  });

  final bool completed;
  final bool isFirst;
  final bool isLast;
  static const double dotTopInset = AppDimensions.sm + 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      child: Column(
        children: [
          SizedBox(
            height: dotTopInset,
            child: line(visible: !isFirst),
          ),
          Dot(completed: completed),
          Expanded(child: line(visible: !isLast)),
        ],
      ),
    );
  }

  Widget line({required bool visible}) {
    return Center(
      child: Container(
        width: 2.5,
        color: visible ? AppColors.timelineLine : Colors.transparent,
      ),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key, required this.completed});

  final bool completed;

  @override
  Widget build(BuildContext context) {
    if (completed) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 2.5),
        ),
        child: const Icon(Icons.check, weight: 30, size: 16, color: AppColors.primary),
      );
    }
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 2.5),
      ),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}