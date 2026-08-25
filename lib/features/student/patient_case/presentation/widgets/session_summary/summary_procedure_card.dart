import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../domain/entities/session_summary_entity.dart';
import '../../models/session_procedure_status.dart';
import '../session/session_procedure_status_chip.dart';

/// Summary row for one treatment item: procedure name + tooth and its status.
class SummaryProcedureCard extends StatelessWidget {
  const SummaryProcedureCard({super.key, required this.item});

  final SummaryTreatmentItemEntity item;

  @override
  Widget build(BuildContext context) {
    final status = sessionProcedureStatusFromApi(item.rawStatus);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tooth #${item.toothNumber} · ${item.procedureName}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Align(
            alignment: Alignment.centerLeft,
            child: SessionProcedureStatusChip(status: status),
          ),
        ],
      ),
    );
  }
}
