import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/planned_procedure_entity.dart';
import '../models/tooth.dart';
import '../utils/procedure_status.dart';
import '../widgets/case_details_top_bar.dart';
import '../widgets/dental_chart/dental_chart.dart';
import '../widgets/dental_chart/planned_procedure_sheet.dart';
import '../widgets/procedure_answers_view.dart';
import '../widgets/progress_timeline_section.dart';

class DentalChartScreen extends StatelessWidget {
  const DentalChartScreen({super.key, required this.procedures});

  final List<PlannedProcedureEntity> procedures;

  @override
  Widget build(BuildContext context) {
    // Planned procedures that target a real tooth, keyed by FDI number.
    final planned = <int, PlannedProcedureEntity>{
      for (final p in procedures)
        if (p.tooth != null) p.tooth!: p,
    };
    final selected = planned.keys.toSet();
    final statusOverrides = <int, ToothStatus>{
      for (final entry in planned.entries)
        entry.key: procedureToothStatus(entry.value.rawStatus),
    };

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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            selected: selected,
                            statusOverrides: statusOverrides,
                            onToothTap: (fdi) {
                              final procedure = planned[fdi];
                              if (procedure != null) {
                                showPlannedProcedureSheet(
                                  context,
                                  procedure: procedure,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Center(
                      child: Text(
                        'Tap a highlighted tooth to view its procedure',
                        style: AppTextStyles.helperText,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xl),
                    Text('Planned Procedures',
                        style: AppTextStyles.sectionTitle),
                    const SizedBox(height: AppDimensions.md),
                    if (procedures.isEmpty)
                      Text('No planned procedures.',
                          style: AppTextStyles.subtitle)
                    else
                      for (var i = 0; i < procedures.length; i++) ...[
                        if (i > 0) const SizedBox(height: AppDimensions.md),
                        _PlannedProcedureCard(procedure: procedures[i]),
                      ],
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

class _PlannedProcedureCard extends StatelessWidget {
  const _PlannedProcedureCard({required this.procedure});

  final PlannedProcedureEntity procedure;

  @override
  Widget build(BuildContext context) {
    final notes = procedure.notes?.trim() ?? '';
    return ProgressTimelineSection(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (procedure.tooth != null)
                Text('Tooth #${procedure.tooth}',
                    style: AppTextStyles.caseToothLabel),
              const Spacer(),
              Text(
                procedureStatusLabel(procedure.rawStatus),
                style: AppTextStyles.statusBadge
                    .copyWith(color: procedureStatusColor(procedure.rawStatus)),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(procedure.procedure, style: AppTextStyles.caseProcedure),
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
