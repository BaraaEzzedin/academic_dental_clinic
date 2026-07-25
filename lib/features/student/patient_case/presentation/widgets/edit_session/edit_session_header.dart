import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_text_style.dart';

// Title + "<session> · <date>" subtitle and the close button for the sheet.
class EditSessionHeader extends StatelessWidget {
  const EditSessionHeader({
    super.key,
    required this.title,
    required this.date,
    required this.onClose,
  });

  final String title;
  final String date;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.xl,
        AppDimensions.lg,
        AppDimensions.lg,
        AppDimensions.lg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit Session', style: _titleStyle),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  '$title · $date',
                  style: AppTextStyles.subtitle.copyWith(fontSize: 15.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
            color: AppColors.textSecondary,
            visualDensity: VisualDensity.compact,
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );
}