import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../models/session_procedure_status.dart';

/// Small status pill for a session procedure, reusing the existing status
/// colors/labels (mirrors [SessionStatusChip]).
class SessionProcedureStatusChip extends StatelessWidget {
  const SessionProcedureStatusChip({super.key, required this.status});

  final SessionProcedureStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            status.label,
            style: AppTextStyles.statusBadge.copyWith(
              color: color,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}
