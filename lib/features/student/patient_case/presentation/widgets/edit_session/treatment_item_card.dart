import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../models/session.dart';
import 'status_selector.dart';

// One tooth/procedure line with its editable status. Tooth and procedure come
// from the treatment plan and are read-only; only the status can change.
class TreatmentItemCard extends StatelessWidget {
  const TreatmentItemCard({
    super.key,
    required this.item,
    required this.onStatusChanged,
  });

  final SessionTreatmentItem item;
  final ValueChanged<SessionStatus> onStatusChanged;

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
                  item.tooth,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Text(
                item.procedure,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          StatusSelector(
            selected: item.status,
            onChanged: onStatusChanged,
          ),
        ],
      ),
    );
  }
}