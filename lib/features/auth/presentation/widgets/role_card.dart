import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

/// A single tappable role option: a left accent bar, a tinted icon circle, and
/// a title + description. Reused for every role, so it holds no role-specific
/// data — everything is passed in.
class RoleCard extends StatelessWidget {
  const RoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.iconBackground = AppColors.logoBorder,
    this.iconColor = AppColors.primary,
    this.accentColor = AppColors.primary,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Color iconBackground;
  final Color iconColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 5, color: accentColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: iconBackground,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: iconColor, size: 26),
                        ),
                        const SizedBox(width: AppDimensions.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: AppTextStyles.topBarTitle),
                              const SizedBox(height: AppDimensions.xs),
                              Text(
                                description,
                                style: AppTextStyles.subtitle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}