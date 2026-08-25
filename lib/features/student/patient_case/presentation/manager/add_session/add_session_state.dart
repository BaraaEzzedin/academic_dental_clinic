import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';


enum AvailableTimesStatus { initial, loading, loaded, error }

class AddSessionState extends Equatable {
  const AddSessionState({
    required this.focusedMonth,
    this.isFirstSession = false,
    this.title = '',
    this.selectedDate,
    this.timesStatus = AvailableTimesStatus.initial,
    this.availableTimes = const [],
    this.selectedTime,
    this.isSubmitting = false,
    this.submitError,
  });

  /// The first session of a case has no appointment: only a title is entered,
  /// so the calendar and available-times sections are hidden.
  final bool isFirstSession;
  final String title;
  final DateTime focusedMonth;
  final DateTime? selectedDate;
  final AvailableTimesStatus timesStatus;
  final List<String> availableTimes;
  final String? selectedTime;
  final bool isSubmitting;
  final String? submitError;

  bool get canSubmit {
    if (isSubmitting || title.trim().isEmpty) return false;
    if (isFirstSession) return true;
    return selectedDate != null && selectedTime != null;
  }

  AddSessionState copyWith({
    bool? isFirstSession,
    String? title,
    DateTime? focusedMonth,
    ValueGetter<DateTime?>? selectedDate,
    AvailableTimesStatus? timesStatus,
    List<String>? availableTimes,
    ValueGetter<String?>? selectedTime,
    bool? isSubmitting,
    ValueGetter<String?>? submitError,
  }) {
    return AddSessionState(
      isFirstSession: isFirstSession ?? this.isFirstSession,
      title: title ?? this.title,
      focusedMonth: focusedMonth ?? this.focusedMonth,
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
        isFirstSession,
        title,
        focusedMonth,
        selectedDate,
        timesStatus,
        availableTimes,
        selectedTime,
        isSubmitting,
        submitError,
      ];
}