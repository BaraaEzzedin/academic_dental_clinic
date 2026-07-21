import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/supervisor_note.dart';

class SupervisorNoteItem extends StatelessWidget {
  const SupervisorNoteItem({super.key, required this.note});

  final SupervisorNote note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.logoBorder,
              backgroundImage:
                  note.avatarUrl != null ? NetworkImage(note.avatarUrl!) : null,
              child: note.avatarUrl == null
                  ? const Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 20,
                    )
                  : null,
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          note.reviewer.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.noteReviewer,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      Text(note.timeAgo, style: AppTextStyles.noteTimeAgo),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Session #${note.session} · ${note.date}',
                    style: AppTextStyles.noteMeta,
                  ),
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
                      note.message,
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