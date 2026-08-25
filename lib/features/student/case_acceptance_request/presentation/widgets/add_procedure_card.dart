import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';

class AddProcedureCard extends StatelessWidget {
  const AddProcedureCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
                vertical: AppDimensions.xl,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.caseChipBackground,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.primary,
                      size: AppDimensions.iconSize,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Add Procedure',
                            style: AppTextStyles.caseProcedure),
                        const SizedBox(height: 2),
                        Text(
                          'Select a procedure and answer its questions',
                          style: AppTextStyles.helperText,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        Text(
          'Tap to add a procedure',
          style: AppTextStyles.helperText,
        ),
      ],
    );
  }
}