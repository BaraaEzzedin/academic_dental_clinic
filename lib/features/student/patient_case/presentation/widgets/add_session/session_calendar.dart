import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import 'session_date_format.dart';

const List<String> _weekdayHeaders = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];


class SessionCalendar extends StatelessWidget {
  const SessionCalendar({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.onSelectDate,
    required this.onPreviousMonth,
    required this.onNextMonth,
    this.enabled = true,
  });

  final DateTime focusedMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onSelectDate;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          _header(),
          const SizedBox(height: AppDimensions.lg),
          _weekdayRow(),
          const SizedBox(height: AppDimensions.sm),
          _daysGrid(),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Text(
          formatMonthYear(focusedMonth),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        _NavButton(
          icon: Icons.chevron_left_rounded,
          onTap: enabled ? onPreviousMonth : null,
        ),
        const SizedBox(width: AppDimensions.sm),
        _NavButton(
          icon: Icons.chevron_right_rounded,
          onTap: enabled ? onNextMonth : null,
        ),
      ],
    );
  }

  Widget _weekdayRow() {
    return Row(
      children: [
        for (final label in _weekdayHeaders)
          Expanded(
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _daysGrid() {
    final firstOfMonth = DateTime(focusedMonth.year, focusedMonth.month);
    final leadingBlanks = firstOfMonth.weekday % 7;
    final daysInMonth =
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final cells = <Widget>[];
    for (var i = 0; i < leadingBlanks; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(focusedMonth.year, focusedMonth.month, day);
      final isPast = date.isBefore(todayDate);
      final isSelected = isSameDay(date, selectedDate);
      cells.add(
        _DayCell(
          day: day,
          isSelected: isSelected,
          isDisabled: !enabled || isPast,
          onTap: () => onSelectDate(date),
        ),
      );
    }
    while (cells.length % 7 != 0) {
      cells.add(const SizedBox.shrink());
    }

    final rows = <Widget>[];
    for (var i = 0; i < cells.length; i += 7) {
      rows.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: i + 7 >= cells.length ? 0 : AppDimensions.xs,
          ),
          child: Row(
            children: [
              for (var j = i; j < i + 7; j++) Expanded(child: cells[j]),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  final int day;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color textColor;
    if (isSelected) {
      textColor = AppColors.white;
    } else if (isDisabled) {
      textColor = AppColors.textHint;
    } else {
      textColor = AppColors.textPrimary;
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xs),
        child: Material(
          color: isSelected ? AppColors.calendarSelectedDay : Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: isDisabled ? null : onTap,
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xs),
        child: Icon(
          icon,
          size: 26,
          color: onTap == null ? AppColors.textHint : AppColors.textSecondary,
        ),
      ),
    );
  }
}