import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../domain/entities/supervisor_note_entity.dart';

class SupervisorNoteItem extends StatelessWidget {
  const SupervisorNoteItem({super.key, required this.note});

  final SupervisorNoteEntity note;

  @override
  Widget build(BuildContext context) {
    final date =
        note.createdAt != null ? DateFormatter.toMediumDate(note.createdAt!) : '';
    final meta = [
      if (note.sessionTitle.isNotEmpty) note.sessionTitle,
      if (date.isNotEmpty) date,
    ].join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.logoBorder,
              child: Icon(
                Icons.person_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.supervisor.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.noteReviewer,
                  ),
                  if (meta.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(meta, style: AppTextStyles.noteMeta),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 3, color: AppColors.primary),
                Expanded(
                  child: Container(
                    color: AppColors.caseChipBackground,
                    padding: const EdgeInsets.all(AppDimensions.md),
                    child: Text(
                      note.notes,
                      style: AppTextStyles.noteMessage,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
