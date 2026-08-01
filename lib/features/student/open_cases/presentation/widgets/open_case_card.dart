import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/widgets/view_details_button.dart';
import '../../domain/entities/open_case_entity.dart';

class OpenCaseCard extends StatelessWidget {
  const OpenCaseCard({super.key, required this.openCase, this.onViewDetails});

  final OpenCaseEntity openCase;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _AccentStrip(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        openCase.patientName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.schedulePatientName,
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.medical_services_outlined,
                            size: 15,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppDimensions.xs),
                          Flexible(
                            child: Text(
                              openCase.subject,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.scheduleSubject,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.md),
                      _ChiefComplaint(text: openCase.chiefComplaint),
                      if (openCase.coordinatorName != null ||
                          openCase.department != null) ...[
                        const SizedBox(height: AppDimensions.md),
                        _MetaRow(openCase: openCase),
                      ],
                      const SizedBox(height: AppDimensions.md),
                      ViewDetailsButton(onPressed: onViewDetails),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccentStrip extends StatelessWidget {
  const _AccentStrip();

  @override
  Widget build(BuildContext context) {
    return Container(width: 5, color: AppColors.primary);
  }
}

class _ChiefComplaint extends StatelessWidget {
  const _ChiefComplaint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.caseChipBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CHIEF COMPLAINT', style: AppTextStyles.caseFieldLabel),
          const SizedBox(height: AppDimensions.xs),
          Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.scheduleMeta.copyWith(height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.openCase});

  final OpenCaseEntity openCase;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.lg,
      runSpacing: AppDimensions.xs,
      children: [
        if (openCase.coordinatorName != null)
          _MetaItem(
            icon: Icons.badge_outlined,
            label: openCase.coordinatorName!,
          ),
        if (openCase.department != null)
          _MetaItem(
            icon: Icons.apartment_outlined,
            label: openCase.department!,
          ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textHint),
        const SizedBox(width: AppDimensions.xs),
        Text(label, style: AppTextStyles.patientFieldLabel),
      ],
    );
  }
}
