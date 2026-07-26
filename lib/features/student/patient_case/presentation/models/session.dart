import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

enum SessionStatus {
  planned,
  inProgress,
  completed,
}

extension SessionStatusX on SessionStatus {
  String get label => switch (this) {
        SessionStatus.planned => 'Planned',
        SessionStatus.inProgress => 'In Progress',
        SessionStatus.completed => 'Completed',
      };

  Color get color => switch (this) {
        SessionStatus.planned => AppColors.warning,
        SessionStatus.inProgress => AppColors.primary,
        SessionStatus.completed => AppColors.success,
      };

  IconData get icon => switch (this) {
        SessionStatus.planned => Icons.schedule_rounded,
        SessionStatus.inProgress => Icons.play_arrow_rounded,
        SessionStatus.completed => Icons.check_rounded,
      };
}

// A single checklist item (procedure/step) tracked within a session.
class SessionItem {
  const SessionItem({required this.label, required this.done});

  final String label;
  final bool done;
}

// A tooth/procedure line inside a session. The tooth and procedure come from
// the treatment plan and are read-only; only [status] is edited in a session.
class SessionTreatmentItem {
  const SessionTreatmentItem({
    required this.tooth,
    required this.procedure,
    required this.status,
  });

  final String tooth;
  final String procedure;
  final SessionStatus status;

  SessionTreatmentItem copyWith({SessionStatus? status}) =>
      SessionTreatmentItem(
        tooth: tooth,
        procedure: procedure,
        status: status ?? this.status,
      );
}

// model for ui , edit when backend is ready
// A single treatment session within a case's progress timeline.
class Session {
  const Session({
    required this.title,
    required this.date,
    required this.status,
    required this.items,
    this.treatmentItems = const [],
    this.note,
  });

  final String title;
  final String date;
  final SessionStatus status;
  final List<SessionItem> items;
  // Tooth/procedure lines whose status is edited from the "Edit Session" sheet.
  final List<SessionTreatmentItem> treatmentItems;
  final String? note;

  int get doneCount => items.where((item) => item.done).length;
  int get totalCount => items.length;

  Session copyWith({
    SessionStatus? status,
    List<SessionTreatmentItem>? treatmentItems,
    // Wrap in `() => value` to override note (including clearing it to null);
    // omit to keep the current note.
    String? Function()? note,
  }) =>
      Session(
        title: title,
        date: date,
        status: status ?? this.status,
        items: items,
        treatmentItems: treatmentItems ?? this.treatmentItems,
        note: note != null ? note() : this.note,
      );
}