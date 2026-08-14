import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_text_style.dart';
import '../../models/session.dart';
import 'session_actions.dart';
import 'session_status_chip.dart';


class SessionDetailCard extends StatelessWidget {
  const SessionDetailCard({
    super.key,
    required this.session,
    this.onViewSummary,
    this.onEdit,
    this.onStart,
    this.onEditSchedule,
  });

  final Session session;
  final VoidCallback? onViewSummary;
  final VoidCallback? onEdit;
  final VoidCallback? onStart;
  final VoidCallback? onEditSchedule;

  @override
  Widget build(BuildContext context) {
    final isActive = session.status == SessionStatus.active;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg + AppDimensions.xs),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.cardBorder,
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.10)
                : const Color(0x0D0F2231),
            blurRadius: isActive ? 18 : 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  session.title,
                  style: AppTextStyles.sessionTitle.copyWith(
                    fontSize: 14.5,
                    color: isActive ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: SessionStatusChip(status: session.status),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Wrap(
            spacing: AppDimensions.lg,
            runSpacing: AppDimensions.xs,
            children: [
              if (session.date.isNotEmpty)
                _MetaChip(
                  icon: Icons.calendar_today_rounded,
                  label: session.date,
                ),
              if (session.time.isNotEmpty)
                _MetaChip(
                  icon: Icons.access_time_rounded,
                  label: session.time,
                ),
            ],
          ),
          if (session.note != null) ...[
            const SizedBox(height: AppDimensions.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppColors.caseChipBackground,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Text(
                session.note!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.noteMessage,
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.lg),
          SessionActions(
            status: session.status,
            onViewSummary: onViewSummary,
            onEdit: onEdit,
            onStart: onStart,
            onEditSchedule: onEditSchedule,
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.textHint),
        const SizedBox(width: AppDimensions.xs),
        Text(
          label,
          style: AppTextStyles.timelinePhaseMeta,
        ),
      ],
    );
  }
}