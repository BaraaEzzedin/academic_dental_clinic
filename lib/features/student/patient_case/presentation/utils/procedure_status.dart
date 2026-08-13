import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../models/tooth.dart';

/// Maps a raw procedure status string (e.g. `in_progress`) to presentation
/// helpers. Kept tolerant: unknown values fall back to neutral defaults.

String _normalize(String? raw) =>
    (raw ?? '').trim().toLowerCase().replaceAll(RegExp(r'[\s-]+'), '_');

/// Human-readable label, e.g. `in_progress` -> "In progress".
String procedureStatusLabel(String? raw) {
  final value = (raw ?? '').trim();
  if (value.isEmpty) return '';
  final words = value.replaceAll(RegExp(r'[_-]+'), ' ').trim();
  if (words.isEmpty) return '';
  return words[0].toUpperCase() + words.substring(1).toLowerCase();
}

Color procedureStatusColor(String? raw) {
  return switch (_normalize(raw)) {
    'completed' => AppColors.success,
    'rejected' => AppColors.error,
    'pending' || 'pending_review' || 'planned' => AppColors.warning,
    'in_progress' => AppColors.primary,
    _ => AppColors.primary,
  };
}

/// Chart color status for a planned tooth.
ToothStatus procedureToothStatus(String? raw) {
  return switch (_normalize(raw)) {
    'completed' => ToothStatus.approved,
    'rejected' => ToothStatus.rejected,
    'pending' || 'pending_review' || 'planned' => ToothStatus.pending,
    _ => ToothStatus.treated,
  };
}
