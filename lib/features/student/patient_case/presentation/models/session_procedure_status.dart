import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

/// Per-procedure status inside a treatment session, mirroring the backend
/// vocabulary `planned` / `in_progress` / `completed`.
enum SessionProcedureStatus {
  planned,
  inProgress,
  completed,
}

extension SessionProcedureStatusX on SessionProcedureStatus {
  String get label => switch (this) {
        SessionProcedureStatus.planned => 'Planned',
        SessionProcedureStatus.inProgress => 'In Progress',
        SessionProcedureStatus.completed => 'Completed',
      };

  Color get color => switch (this) {
        SessionProcedureStatus.planned => AppColors.warning,
        SessionProcedureStatus.inProgress => AppColors.primary,
        SessionProcedureStatus.completed => AppColors.success,
      };

  IconData get icon => switch (this) {
        SessionProcedureStatus.planned => Icons.schedule_rounded,
        SessionProcedureStatus.inProgress => Icons.play_arrow_rounded,
        SessionProcedureStatus.completed => Icons.check_rounded,
      };

  /// The raw value sent back to the API.
  String get apiValue => switch (this) {
        SessionProcedureStatus.planned => 'planned',
        SessionProcedureStatus.inProgress => 'in_progress',
        SessionProcedureStatus.completed => 'completed',
      };
}

/// Maps a raw backend status string to a [SessionProcedureStatus]; unknown
/// values fall back to `planned`.
SessionProcedureStatus sessionProcedureStatusFromApi(String? value) {
  return switch (value?.toLowerCase()) {
    'in_progress' => SessionProcedureStatus.inProgress,
    'completed' => SessionProcedureStatus.completed,
    'planned' => SessionProcedureStatus.planned,
    _ => SessionProcedureStatus.planned,
  };
}
