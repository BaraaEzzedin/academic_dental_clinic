import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_text_style.dart';

enum _StepStatus { completed, active, upcoming }


class AppStepper extends StatelessWidget {
  const AppStepper({
    super.key,
    required this.currentStep,
    required this.titles,
    this.totalSteps,
  }) : assert(titles.length > 0, 'A stepper needs at least one step.');


  final int currentStep;

  final List<String> titles;

  final int? totalSteps;

  static const double _circleSize = 34;

  static const double _lineThickness = 3;

  @override
  Widget build(BuildContext context) {
    final int count = (totalSteps == null || totalSteps! < titles.length)
        ? titles.length
        : totalSteps!;

    return Column(
      children: [
        _buildTimeline(count),
        const SizedBox(height: AppDimensions.sm),
        _buildTitles(count),
      ],
    );
  }


  Widget _buildTimeline(int count) {
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < count; i++) {
      children.add(_StepCircle(index: i, status: _statusFor(i)));
      if (i < count - 1) {
        children.add(
          Expanded(
            child: Container(
              height: _lineThickness,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              color: currentStep > i
                  ? AppColors.primary
                  : AppColors.indicatorInactive,
            ),
          ),
        );
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }


  Widget _buildTitles(int count) {
    return Row(
      children: [
        for (int i = 0; i < count; i++)
          Expanded(
            child: Text(
              i < titles.length ? titles[i] : '',
              textAlign: _titleAlign(i, count),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _titleStyle(_statusFor(i)),
            ),
          ),
      ],
    );
  }

  TextAlign _titleAlign(int index, int count) {
    if (index == 0) return TextAlign.start;
    if (index == count - 1) return TextAlign.end;
    return TextAlign.center;
  }

  _StepStatus _statusFor(int index) {
    if (index < currentStep) return _StepStatus.completed;
    if (index == currentStep) return _StepStatus.active;
    return _StepStatus.upcoming;
  }

  static TextStyle _titleStyle(_StepStatus status) {
    switch (status) {
      case _StepStatus.active:
        return AppTextStyles.stepTitleActive;
      case _StepStatus.completed:
        return AppTextStyles.stepTitleCompleted;
      case _StepStatus.upcoming:
        return AppTextStyles.stepTitleInactive;
    }
  }
}


class _StepCircle extends StatelessWidget {
  const _StepCircle({required this.index, required this.status});

  final int index;
  final _StepStatus status;

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == _StepStatus.active;
    final bool isCompleted = status == _StepStatus.completed;
    final bool isFilled = isActive || isCompleted;

    return Container(
      width: AppStepper._circleSize,
      height: AppStepper._circleSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isFilled ? AppColors.primary : AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isFilled ? AppColors.primary : AppColors.indicatorInactive,
          width: 1.5,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: isCompleted
          ? const Icon(Icons.check_rounded, size: 18, color: AppColors.white)
          : Text(
              '${index + 1}',
              style: AppTextStyles.stepNumber.copyWith(
                color: isActive ? AppColors.white : AppColors.textHint,
              ),
            ),
    );
  }
}