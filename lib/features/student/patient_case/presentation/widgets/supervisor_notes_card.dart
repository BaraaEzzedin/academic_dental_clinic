import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../models/supervisor_note.dart';
import 'progress_timeline_section.dart';
import 'supervisor_note_item.dart';

class SupervisorNotesCard extends StatelessWidget {
  const SupervisorNotesCard({super.key, required this.notes});

  final List<SupervisorNote> notes;

  @override
  Widget build(BuildContext context) {
    return ProgressTimelineSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Supervisor Notes'),
          const SizedBox(height: AppDimensions.lg),
          if (notes.isEmpty)
            Text('No notes yet.', style: AppTextStyles.timelinePhaseMeta)
          else
            for (var i = 0; i < notes.length; i++) ...[
              if (i > 0) ...[
                const SizedBox(height: AppDimensions.md),
                const Divider(height: 1, color: AppColors.dividerLine),
                const SizedBox(height: AppDimensions.md),
              ],
              SupervisorNoteItem(note: notes[i]),
            ],
        ],
      ),
    );
  }
}