import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../patient_case/presentation/widgets/progress_timeline_section.dart';
import '../../domain/entities/subject_details_entity.dart';

/// Summary card at the top of the Subject Details screen: subject name,
/// section and supervisor.
class SubjectHeaderCard extends StatelessWidget {
  const SubjectHeaderCard({super.key, required this.details});

  final SubjectDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  color: AppColors.primary,
                  size: AppDimensions.iconSize,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Text(
                  details.subject,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.casePatientName,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          const Divider(height: 1, color: AppColors.dividerLine),
          const SizedBox(height: AppDimensions.md),
          _MetaRow(
            icon: Icons.layers_rounded,
            label: 'Section',
            value: details.section,
          ),
          const SizedBox(height: AppDimensions.md),
          _MetaRow(
            icon: Icons.person_rounded,
            label: 'Supervisor',
            value: details.supervisor,
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label.toUpperCase(), style: AppTextStyles.caseFieldLabel),
              const SizedBox(height: AppDimensions.xs),
              Text(
                value.isEmpty ? '—' : value,
                style: AppTextStyles.caseFieldValue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
