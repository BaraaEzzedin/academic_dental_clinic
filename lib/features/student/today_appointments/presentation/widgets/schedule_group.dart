import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/today_appointment_entity.dart';
import 'schedule_item_card.dart';

/// A labelled group of appointments (e.g. "Today" or "Upcoming") rendered as a
/// timeline. The [label] mirrors the backend grouping key; [items] are shown in
/// order, unmodified.
class ScheduleGroup extends StatelessWidget {
  const ScheduleGroup({
    super.key,
    required this.label,
    required this.items,
    this.showDate = false,
    this.onItemTap,
  });

  final String label;
  final List<AppointmentEntity> items;

  /// Surfaces the per-item date — used for the "upcoming" group.
  final bool showDate;
  final void Function(AppointmentEntity item)? onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.homeDateLabel),
        const SizedBox(height: AppDimensions.md),
        for (var i = 0; i < items.length; i++)
          ScheduleItemCard(
            item: items[i],
            isFirst: i == 0,
            isLast: i == items.length - 1,
            showDate: showDate,
            onTap: onItemTap == null ? null : () => onItemTap!(items[i]),
          ),
      ],
    );
  }
}