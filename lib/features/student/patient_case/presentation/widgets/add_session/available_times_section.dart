import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../manager/add_session/add_session_state.dart';
import '../../../../../../core/utils/date_formatter.dart';


class AvailableTimesSection extends StatelessWidget {
  const AvailableTimesSection({
    super.key,
    required this.selectedDate,
    required this.status,
    required this.times,
    required this.selectedTime,
    required this.onSelectTime,
  });

  final DateTime? selectedDate;
  final AvailableTimesStatus status;
  final List<String> times;
  final String? selectedTime;
  final ValueChanged<String> onSelectTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Available Times',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            if (selectedDate != null)
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  Text(
                    DateFormatter.toDayLabel(selectedDate!),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.md),
        _body(),
      ],
    );
  }

  Widget _body() {
    switch (status) {
      case AvailableTimesStatus.initial:
        return Text(
          'Pick a day to see available times.',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textHint,
          ),
        );
      case AvailableTimesStatus.loading:
        return const _LoadingChips();
      case AvailableTimesStatus.error:
        return Text(
          'Could not load times. Please try again.',
          style: const TextStyle(fontSize: 14, color: AppColors.error),
        );
      case AvailableTimesStatus.loaded:
        if (times.isEmpty) {
          return Text(
            'No available times for this day.',
            style: const TextStyle(fontSize: 14, color: AppColors.textHint),
          );
        }
        return Wrap(
          spacing: AppDimensions.md,
          runSpacing: AppDimensions.md,
          children: [
            for (final time in times)
              _TimeChip(
                label: time,
                isSelected: time == selectedTime,
                onTap: () => onSelectTime(time),
              ),
          ],
        );
    }
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.lg,
          vertical: AppDimensions.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.fieldBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isSelected ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}


class _LoadingChips extends StatelessWidget {
  const _LoadingChips();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.md,
      runSpacing: AppDimensions.md,
      children: List.generate(3, (_) => const _SkeletonChip()),
    );
  }
}

class _SkeletonChip extends StatefulWidget {
  const _SkeletonChip();

  @override
  State<_SkeletonChip> createState() => _SkeletonChipState();
}

class _SkeletonChipState extends State<_SkeletonChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.4, end: 0.9).animate(_controller),
      child: Container(
        width: 108,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.fieldBorder),
        ),
      ),
    );
  }
}