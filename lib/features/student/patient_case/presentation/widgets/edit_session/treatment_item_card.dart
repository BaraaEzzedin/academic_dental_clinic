import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../domain/entities/session_procedure_entity.dart';
import '../../models/session_procedure_status.dart';
import 'status_selector.dart';

class TreatmentItemCard extends StatelessWidget {
  const TreatmentItemCard({
    super.key,
    required this.procedure,
    required this.selected,
    required this.onStatusChanged,
  });

  final SessionProcedureEntity procedure;
  final SessionProcedureStatus selected;
  final ValueChanged<SessionProcedureStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Tooth #${procedure.toothNumber}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Flexible(
                child: Text(
                  procedure.name,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          StatusSelector(
            selected: selected,
            onChanged: onStatusChanged,
          ),
        ],
      ),
    );
  }
}
