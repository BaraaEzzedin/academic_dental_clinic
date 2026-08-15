import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../notifications/presentation/screens/notifications_screen.dart';


class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
    required this.studentName,
    this.onNotificationsTap,
  });

  final String studentName;

  /// Called when the notification icon is tapped. Defaults to opening the
  /// [NotificationsScreen] so every screen using this bar gets it for free.
  final VoidCallback? onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.topBarBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.logoBorder,
            child: Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Text(
              studentName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.homeUserName,
            ),
          ),
          IconButton(
            onPressed: onNotificationsTap ??
                () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    ),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textSecondary,
            ),
            splashRadius: 22,
          ),
        ],
      ),
    );
  }
}