import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/treatment_plan.dart';
import 'plan_highlight_chip.dart';
import 'section_card.dart';
import 'treatment_plan_row.dart';

class TreatmentPlanSummaryCard extends StatelessWidget {
  const TreatmentPlanSummaryCard({
    super.key,
    required this.rows,
    required this.highlights,
    this.onViewDentalChart,
  });

  final List<TreatmentPlanRow> rows;
  final List<PlanHighlight> highlights;
  final VoidCallback? onViewDentalChart;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Treatment Plan Summary'),
          const SizedBox(height: AppDimensions.md),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) ...[
              const SizedBox(height: AppDimensions.sm),
              const Divider(height: 1, color: AppColors.dividerLine),
              const SizedBox(height: AppDimensions.sm),
            ],
            TreatmentPlanRowTile(row: rows[i]),
          ],
          if (highlights.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < highlights.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppDimensions.md),
                  Expanded(child: PlanHighlightChip(highlight: highlights[i])),
                ],
              ],
            ),
          ],
          const SizedBox(height: AppDimensions.lg),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onViewDentalChart,
              icon: const Icon(Icons.grid_view_rounded, size: 18),
              label: const Text('View Dental Chart'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                textStyle: AppTextStyles.viewDetailsButton,
              ),
            ),
          ),
        ],
      ),
    );
  }
}