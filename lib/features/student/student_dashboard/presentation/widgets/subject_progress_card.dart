import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../clinical_courses/presentation/widgets/subject_progress_bar.dart';
import '../../domain/entities/student_dashboard_entity.dart';
import 'dashboard_section.dart';

/// A single subject's progress: name, supervisor, section and a linear bar.
class SubjectProgressCard extends StatelessWidget {
  const SubjectProgressCard({super.key, required this.subject});

  final DashboardSubjectEntity subject;

  @override
  Widget build(BuildContext context) {
    final percent = subject.completionPercentage;
    final section = subject.sectionName.trim();
    final supervisor = subject.supervisor.trim();

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject.name, style: AppTextStyles.sessionsHeading),
                    if (supervisor.isNotEmpty) ...[
                      const SizedBox(height: AppDimensions.xs),
                      _MetaRow(
                        icon: Icons.person_rounded,
                        text: supervisor,
                      ),
                    ],
                    if (section.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      _MetaRow(
                        icon: Icons.meeting_room_rounded,
                        text: section,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Text(
                '${_trim(percent)}%',
                style: AppTextStyles.caseHighlightValue.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          SubjectProgressBar(value: percent / 100),
          const SizedBox(height: AppDimensions.sm),
          Text(
            '${subject.completedProcedures} / ${subject.requiredProcedures} procedures',
            style: AppTextStyles.timelinePhaseMeta,
          ),
        ],
      ),
    );
  }

  static String _trim(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: AppDimensions.xs),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.scheduleSubject,
          ),
        ),
      ],
    );
  }
}
