import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../../domain/entities/planned_procedure_entity.dart';
import '../../utils/procedure_status.dart';
import '../procedure_answers_view.dart';

/// View-only detail sheet for a planned procedure on a tooth. Shows the tooth
/// number, procedure name, status, notes and all answers.
Future<void> showPlannedProcedureSheet(
  BuildContext context, {
  required PlannedProcedureEntity procedure,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scroll) => _PlannedProcedureSheet(
        procedure: procedure,
        scrollController: scroll,
      ),
    ),
  );
}

class _PlannedProcedureSheet extends StatelessWidget {
  const _PlannedProcedureSheet({
    required this.procedure,
    required this.scrollController,
  });

  final PlannedProcedureEntity procedure;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final notes = procedure.notes?.trim() ?? '';
    final statusColor = procedureStatusColor(procedure.rawStatus);
    final statusLabel = procedureStatusLabel(procedure.rawStatus);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.dividerLine,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.lg,
                AppDimensions.lg,
                AppDimensions.lg,
                AppDimensions.xl,
              ),
              children: [
                Row(
                  children: [
                    if (procedure.tooth != null)
                      Text(
                        'Tooth #${procedure.tooth}',
                        style: AppTextStyles.casePatientName,
                      ),
                    const Spacer(),
                    if (statusLabel.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.md,
                          vertical: AppDimensions.xs,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusXl),
                        ),
                        child: Text(
                          statusLabel,
                          style: AppTextStyles.statusBadge
                              .copyWith(color: statusColor),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(procedure.procedure, style: AppTextStyles.caseProcedure),
                if (procedure.answers.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.lg),
                  ProcedureAnswersView(answers: procedure.answers),
                ],
                if (notes.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.lg),
                  Text('NOTES', style: AppTextStyles.caseFieldLabel),
                  const SizedBox(height: AppDimensions.xs),
                  Text(notes, style: AppTextStyles.caseToothLabel),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
