import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../patient_case/presentation/widgets/progress_timeline_section.dart';
import '../../domain/entities/procedure_request_entity.dart';
import 'selected_procedure_card.dart';

class SelectedProceduresSection extends StatelessWidget {
  const SelectedProceduresSection({
    super.key,
    required this.requests,
    required this.emptyMessage,
    required this.onEdit,
    required this.onRemove,
  });

  final List<ProcedureRequestEntity> requests;
  final String emptyMessage;
  final ValueChanged<ProcedureRequestEntity> onEdit;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: SectionTitle('Selected Procedures')),
            if (requests.isNotEmpty) _CountBadge(count: requests.length),
          ],
        ),
        const SizedBox(height: AppDimensions.md),
        if (requests.isEmpty)
          _NoSelectionMessage(message: emptyMessage)
        else
          for (var i = 0; i < requests.length; i++) ...[
            if (i > 0) const SizedBox(height: AppDimensions.sm),
            SelectedProcedureCard(
              request: requests[i],
              onEdit: () => onEdit(requests[i]),
              onRemove: () => onRemove(requests[i].localId),
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
  const _NoSelectionMessage({required this.message});

  final String message;

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
              message,
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