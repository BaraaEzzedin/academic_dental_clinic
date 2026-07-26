import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../models/session.dart';
import 'session_detail_card.dart';


class SessionTimelineItem extends StatelessWidget {
  const SessionTimelineItem({
    super.key,
    required this.session,
    required this.isLast,
    this.onViewSummary,
    this.onEdit,
  });

  final Session session;
  final bool isLast;
  final VoidCallback? onViewSummary;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final color = session.status.color;
    final isActive = session.status == SessionStatus.inProgress;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.25),
                            spreadRadius: 3,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  session.status.icon,
                  size: 18,
                  color: AppColors.white,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin:
                        const EdgeInsets.symmetric(vertical: AppDimensions.xs),
                    color: AppColors.timelineLine,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimensions.lg),
              child: SessionDetailCard(
                session: session,
                onViewSummary: onViewSummary,
                onEdit: onEdit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}