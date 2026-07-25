import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/treatment_plan.dart';
import 'progress_timeline_section.dart';
import 'treatment_plan_row.dart';

class TreatmentPlanSummaryCard extends StatelessWidget {
  const TreatmentPlanSummaryCard({
    super.key,
    required this.rows,
    required this.materials,
    this.onViewDentalChart,
  });

  final List<TreatmentPlanRow> rows;
  final List<String> materials;
  final VoidCallback? onViewDentalChart;

  @override
  Widget build(BuildContext context) {
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Treatment Plan Summary'),
          const SizedBox(height: AppDimensions.md),
          // Target teeth: title over the planned teeth + procedures list.
          TitledContainer(
            title: 'Target Teeth',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  if (i > 0) ...[
                    const SizedBox(height: AppDimensions.sm),
                    const Divider(height: 1, color: AppColors.dividerLine),
                    const SizedBox(height: AppDimensions.sm),
                  ],
                  TreatmentPlanRowTile(row: rows[i]),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          // Materials: title over the materials used list.
          TitledContainer(
            title: 'Materials',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final material in materials)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.xs),
                    child: MaterialItem(name: material),
                  ),
              ],
            ),
          ),
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

// Tinted rounded container with an uppercase title over its body list.
class TitledContainer extends StatelessWidget {
  const TitledContainer({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: AppTextStyles.caseFieldLabel),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.sm),
            child: Divider(height: 1, color: AppColors.dividerLine),
          ),
          child,
        ],
      ),
    );
  }
}

class MaterialItem extends StatelessWidget {
  const MaterialItem({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.fiber_manual_record,
          size: 7,
          color: AppColors.primary,
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caseProcedure,
          ),
        ),
      ],
    );
  }
}