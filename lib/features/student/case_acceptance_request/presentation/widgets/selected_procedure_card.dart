import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../domain/entities/procedure_request_entity.dart';

class SelectedProcedureCard extends StatelessWidget {
  const SelectedProcedureCard({
    super.key,
    required this.request,
    required this.onEdit,
    required this.onRemove,
  });

  final ProcedureRequestEntity request;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final hasDetails = request.answers.isNotEmpty || request.hasNotes;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _LeadingChip(toothNumber: request.toothNumber),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.hasTooth
                          ? 'Tooth #${request.toothNumber}'
                          : 'Procedure',
                      style: AppTextStyles.caseToothLabel,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      request.procedureName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caseProcedure,
                    ),
                  ],
                ),
              ),
              _ActionButton(
                icon: Icons.edit_outlined,
                tooltip: 'Edit',
                onTap: onEdit,
              ),
              _ActionButton(
                icon: Icons.delete_outline_rounded,
                tooltip: 'Delete',
                onTap: onRemove,
              ),
            ],
          ),
          if (hasDetails) ...[
            const SizedBox(height: AppDimensions.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppColors.caseChipBackground,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < request.answers.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppDimensions.md),
                    _DetailBlock(
                      label: request.answers[i].questionText,
                      value: request.answers[i].displayAnswer,
                    ),
                  ],
                  if (request.hasNotes) ...[
                    if (request.answers.isNotEmpty)
                      const SizedBox(height: AppDimensions.md),
                    _DetailBlock(label: 'Notes', value: request.notes),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LeadingChip extends StatelessWidget {
  const _LeadingChip({required this.toothNumber});

  final int? toothNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: toothNumber != null
          ? Text('#$toothNumber', style: AppTextStyles.caseHighlightValue)
          : const Icon(
              Icons.medical_services_outlined,
              color: AppColors.primary,
              size: AppDimensions.iconSize,
            ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.caseFieldLabel),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.noteMessage.copyWith(fontSize: 13.5),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: AppColors.textSecondary, size: 20),
      splashRadius: 20,
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
    );
  }
}