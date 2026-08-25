import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../domain/entities/procedure_progress_entity.dart';

/// Presentation mapping for [ProcedureCompletion] — reuses existing app colors.
extension ProcedureCompletionUiX on ProcedureCompletion {
  String get label => switch (this) {
        ProcedureCompletion.notStarted => 'Not Started',
        ProcedureCompletion.inProgress => 'In Progress',
        ProcedureCompletion.completed => 'Completed',
      };

  Color get color => switch (this) {
        ProcedureCompletion.notStarted => AppColors.textHint,
        ProcedureCompletion.inProgress => AppColors.warning,
        ProcedureCompletion.completed => AppColors.success,
      };
}
