import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../patient_case/presentation/widgets/progress_timeline_section.dart';
import '../../domain/entities/available_procedure_entity.dart';
import 'selected_procedure_card.dart';

class SelectedProceduresSection extends StatelessWidget {
  const SelectedProceduresSection({
    super.key,
    required this.selections,
    required this.onEdit,
    required this.onRemove,
  });

  final List<MapEntry<int, AvailableProcedureEntity>> selections;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: SectionTitle('Selected Procedures')),
            if (selections.isNotEmpty) _CountBadge(count: selections.length),
          ],
        ),
        const SizedBox(height: AppDimensions.md),
        if (selections.isEmpty)
          const _NoSelectionMessage()
        else
          for (var i = 0; i < selections.length; i++) ...[
            if (i > 0) const SizedBox(height: AppDimensions.sm),
            SelectedProcedureCard(
              toothNumber: selections[i].key,
              procedure: selections[i].value,
              onEdit: () => onEdit(selections[i].key),
              onRemove: () => onRemove(selections[i].key),
            ),
          ],
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Text(
        '$count',
        style: AppTextStyles.scheduleMeta.copyWith(color: AppColors.primary),
      ),
    );
  }
}


class _NoSelectionMessage extends StatelessWidget {
  const _NoSelectionMessage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.error, size: 20),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Text(
              'Please select at least one tooth and procedure.',
              style: AppTextStyles.subtitle.copyWith(
                fontSize: 13.5,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}