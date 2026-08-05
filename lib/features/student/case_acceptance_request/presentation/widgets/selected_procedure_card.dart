import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/available_procedure_entity.dart';

class SelectedProcedureCard extends StatelessWidget {
  const SelectedProcedureCard({
    super.key,
    required this.toothNumber,
    required this.procedure,
    required this.onEdit,
    required this.onRemove,
  });

  final int toothNumber;
  final AvailableProcedureEntity procedure;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.caseChipBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Text(
                  '#$toothNumber',
                  style: AppTextStyles.caseHighlightValue,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tooth #$toothNumber',
                        style: AppTextStyles.caseToothLabel),
                    const SizedBox(height: 2),
                    Text(
                      procedure.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caseProcedure,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.close_rounded,
                    color: AppColors.textSecondary, size: 20),
                splashRadius: 20,
                tooltip: 'Remove',
              ),
            ],
          ),
        ),
      ),
    );
  }
}