import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/schedule_item.dart';
import 'schedule_item_card.dart';


class TodayScheduleSection extends StatelessWidget {
  const TodayScheduleSection({
    super.key,
    required this.items,
    this.onItemTap,
  });

  final List<ScheduleItem> items;
  final void Function(ScheduleItem item)? onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's Schedule", style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppDimensions.lg),
        for (var i = 0; i < items.length; i++)
          ScheduleItemCard(
            item: items[i],
            isFirst: i == 0,
            isLast: i == items.length - 1,
            onTap: onItemTap == null ? null : () => onItemTap!(items[i]),
          ),
      ],
    );
  }
}