import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

// Session lifecycle statuses, mirroring the backend exactly:
// `active` (in progress), `upcoming` (scheduled), `completed`.
enum SessionStatus {
  active,
  upcoming,
  completed,
}

extension SessionStatusX on SessionStatus {
  String get label => switch (this) {
        SessionStatus.active => 'Active',
        SessionStatus.upcoming => 'Upcoming',
        SessionStatus.completed => 'Completed',
      };

  Color get color => switch (this) {
        SessionStatus.active => AppColors.primary,
        SessionStatus.upcoming => AppColors.warning,
        SessionStatus.completed => AppColors.success,
      };

  IconData get icon => switch (this) {
        SessionStatus.active => Icons.play_arrow_rounded,
        SessionStatus.upcoming => Icons.schedule_rounded,
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
    this.id = 0,
    this.time = '',
    this.appointmentDate,
    this.startTimeRaw = '',
    this.treatmentItems = const [],
    this.note,
  });

  /// Backend `sessionId`, used to load/complete the session.
  final int id;
  final String title;
  final String date;
  // Formatted appointment start time (e.g. "10:30 AM"); empty when unscheduled.
  final String time;
  // Raw appointment values, used to pre-fill the edit-schedule sheet.
  final DateTime? appointmentDate;
  final String startTimeRaw;
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
        id: id,
        title: title,
        date: date,
        time: time,
        appointmentDate: appointmentDate,
        startTimeRaw: startTimeRaw,
        status: status ?? this.status,
        items: items,
        treatmentItems: treatmentItems ?? this.treatmentItems,
        note: note != null ? note() : this.note,
      );
}