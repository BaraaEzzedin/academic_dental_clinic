import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/planned_procedure_entity.dart';
import '../models/treatment_plan.dart';
import 'procedure_answers_view.dart';
import 'progress_timeline_section.dart';
import 'treatment_plan_row.dart';

class TreatmentPlanSummaryCard extends StatelessWidget {
  const TreatmentPlanSummaryCard({
    super.key,
    required this.procedures,
    required this.materials,
    required this.requiresDentalChart,
    this.onViewDentalChart,
  });

  final List<PlannedProcedureEntity> procedures;
  final List<String> materials;

  /// When `true`, the plan is tooth-based (Target Teeth rows + dental chart);
  /// otherwise procedures are shown as icon cards.
  final bool requiresDentalChart;
  final VoidCallback? onViewDentalChart;

  @override
  Widget build(BuildContext context) {
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Treatment Plan Summary'),
          const SizedBox(height: AppDimensions.md),
          if (requiresDentalChart)
            _TargetTeethSection(procedures: procedures)
          else
            _ProceduresSection(procedures: procedures),
          const SizedBox(height: AppDimensions.md),
          TitledContainer(
            title: 'Materials',
            child: materials.isEmpty
                ? Text('No materials recorded.',
                    style: AppTextStyles.timelinePhaseMeta)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final material in materials)
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppDimensions.xs),
                          child: MaterialItem(name: material),
                        ),
                    ],
                  ),
          ),
          if (requiresDentalChart) ...[
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
                  padding:
                      const EdgeInsets.symmetric(vertical: AppDimensions.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  textStyle: AppTextStyles.viewDetailsButton,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Scenario A — tooth-based plan: title over the planned teeth + procedures.
class _TargetTeethSection extends StatelessWidget {
  const _TargetTeethSection({required this.procedures});

  final List<PlannedProcedureEntity> procedures;

  @override
  Widget build(BuildContext context) {
    return TitledContainer(
      title: 'Target Teeth',
      child: procedures.isEmpty
          ? Text('No target teeth planned yet.',
              style: AppTextStyles.timelinePhaseMeta)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < procedures.length; i++) ...[
                  if (i > 0) ...[
                    const SizedBox(height: AppDimensions.sm),
                    const Divider(height: 1, color: AppColors.dividerLine),
                    const SizedBox(height: AppDimensions.sm),
                  ],
                  TreatmentPlanRowTile(
                    row: TreatmentPlanRow(
                      tooth: procedures[i].tooth != null
                          ? 'Tooth #${procedures[i].tooth}'
                          : '—',
                      procedure: procedures[i].procedure,
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

// Scenario B — procedure-based plan: one icon card per procedure with its
// answers and notes (no tooth number, no dental chart).
class _ProceduresSection extends StatelessWidget {
  const _ProceduresSection({required this.procedures});

  final List<PlannedProcedureEntity> procedures;

  @override
  Widget build(BuildContext context) {
    if (procedures.isEmpty) {
      return TitledContainer(
        title: 'Procedures',
        child: Text('No procedures planned yet.',
            style: AppTextStyles.timelinePhaseMeta),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < procedures.length; i++) ...[
          if (i > 0) const SizedBox(height: AppDimensions.sm),
          ProcedurePlanCard(procedure: procedures[i]),
        ],
      ],
    );
  }
}

/// A single procedure card for the procedure-based (non-dental) workflow.
class ProcedurePlanCard extends StatelessWidget {
  const ProcedurePlanCard({super.key, required this.procedure});

  final PlannedProcedureEntity procedure;

  @override
  Widget build(BuildContext context) {
    final notes = procedure.notes?.trim() ?? '';
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Text(
                  procedure.procedure,
                  style: AppTextStyles.caseProcedure,
                ),
              ),
            ],
          ),
          if (procedure.answers.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.md),
            ProcedureAnswersView(answers: procedure.answers),
          ],
          if (notes.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.md),
            Text('NOTES', style: AppTextStyles.caseFieldLabel),
            const SizedBox(height: AppDimensions.xs),
            Text(notes, style: AppTextStyles.caseToothLabel),
          ],
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
