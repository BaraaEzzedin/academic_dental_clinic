import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../../../core/utils/date_formatter.dart';
import '../add_session/add_session_state.dart' show AvailableTimesStatus;

/// State for editing an upcoming session's schedule (title + appointment). Only
/// changed fields are submitted, so the original values are kept for diffing.
class EditScheduleState extends Equatable {
  const EditScheduleState({
    required this.focusedMonth,
    required this.originalTitle,
    required this.originalDate,
    required this.originalTime,
    this.title = '',
    this.selectedDate,
    this.timesStatus = AvailableTimesStatus.initial,
    this.availableTimes = const [],
    this.selectedTime,
    this.isSubmitting = false,
    this.submitError,
  });

  final DateTime focusedMonth;
  final String originalTitle;
  final DateTime? originalDate;

  /// Original start time, normalized to `HH:mm`.
  final String originalTime;

  final String title;
  final DateTime? selectedDate;
  final AvailableTimesStatus timesStatus;
  final List<String> availableTimes;
  final String? selectedTime;
  final bool isSubmitting;
  final String? submitError;

  bool get titleChanged => title.trim() != originalTitle.trim();

  bool get dateDiffersFromOriginal =>
      !DateFormatter.isSameDay(selectedDate, originalDate);

  /// The appointment (date + time) differs from the original and is complete.
  bool get scheduleChanged =>
      selectedDate != null &&
      selectedTime != null &&
      (dateDiffersFromOriginal || selectedTime != originalTime);

  bool get canSubmit {
    if (isSubmitting || title.trim().isEmpty) return false;
    // Changing the day requires re-picking a time before saving.
    if (dateDiffersFromOriginal && selectedTime == null) return false;
    return titleChanged || scheduleChanged;
  }

  EditScheduleState copyWith({
    DateTime? focusedMonth,
    String? title,
    ValueGetter<DateTime?>? selectedDate,
    AvailableTimesStatus? timesStatus,
    List<String>? availableTimes,
    ValueGetter<String?>? selectedTime,
    bool? isSubmitting,
    ValueGetter<String?>? submitError,
  }) {
    return EditScheduleState(
      focusedMonth: focusedMonth ?? this.focusedMonth,
      originalTitle: originalTitle,
      originalDate: originalDate,
      originalTime: originalTime,
      title: title ?? this.title,
      selectedDate: selectedDate != null ? selectedDate() : this.selectedDate,
      timesStatus: timesStatus ?? this.timesStatus,
      availableTimes: availableTimes ?? this.availableTimes,
      selectedTime: selectedTime != null ? selectedTime() : this.selectedTime,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: submitError != null ? submitError() : this.submitError,
    );
  }

  @override
  List<Object?> get props => [
        focusedMonth,
        originalTitle,
        originalDate,
        originalTime,
        title,
        selectedDate,
        timesStatus,
        availableTimes,
        selectedTime,
        isSubmitting,
        submitError,
      ];
}
