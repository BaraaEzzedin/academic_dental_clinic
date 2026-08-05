import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../patient_case/presentation/widgets/dental_chart/dental_chart.dart';


class DentalChartCard extends StatelessWidget {
  const DentalChartCard({
    super.key,
    required this.selectedTeeth,
    required this.onToothTap,
  });

  final Set<int> selectedTeeth;
  final ValueChanged<int> onToothTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.sm,
            AppDimensions.xl,
            AppDimensions.sm,
            AppDimensions.lg,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              DentalChart(
                selected: selectedTeeth,
                onToothTap: onToothTap,
              ),
              const SizedBox(height: AppDimensions.lg),
              //const DentalChartLegend(),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        Text(
          'Tap a tooth to assign a procedure',
          style: AppTextStyles.helperText,
        ),
      ],
    );
  }
}