import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/tooth.dart';
import '../widgets/case_details_top_bar.dart';
import '../widgets/dental_chart/dental_chart.dart';
import '../widgets/dental_chart/dental_chart_legend.dart';
import '../widgets/dental_chart/tooth_detail_sheet.dart';

class DentalChartScreen extends StatelessWidget {
  const DentalChartScreen({super.key, required this.records});

  final Map<int, ToothRecord> records;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.screenHorizontalPadding,
                AppDimensions.lg,
                AppDimensions.screenHorizontalPadding,
                AppDimensions.lg,
              ),
              child: CaseDetailsTopBar(title: 'Dental Chart'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.screenHorizontalPadding,
                  0,
                  AppDimensions.screenHorizontalPadding,
                  AppDimensions.xl,
                ),
                child: Column(
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
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusXl),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          DentalChart(
                            records: records,
                            onToothTap: (fdi) => showToothDetailSheet(
                              context,
                              fdi: fdi,
                              record: records[fdi],
                            ),
                          ),
                          const SizedBox(height: AppDimensions.lg),
                          const DentalChartLegend(),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Text(
                      'Tap a tooth to open its treatment record',
                      style: AppTextStyles.helperText,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}