import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';


enum AvailableTimesStatus { initial, loading, loaded, error }

class AddSessionState extends Equatable {
  const AddSessionState({
    required this.focusedMonth,
    this.title = '',
    this.selectedDate,
    this.timesStatus = AvailableTimesStatus.initial,
    this.availableTimes = const [],
    this.selectedTime,
    this.isSubmitting = false,
  });

  final String title;
  final DateTime focusedMonth;
  final DateTime? selectedDate;
  final AvailableTimesStatus timesStatus;
  final List<String> availableTimes;
  final String? selectedTime;
  final bool isSubmitting;

  bool get canSubmit =>
      title.trim().isNotEmpty &&
      selectedDate != null &&
      selectedTime != null &&
      !isSubmitting;

  AddSessionState copyWith({
    String? title,
    DateTime? focusedMonth,
    ValueGetter<DateTime?>? selectedDate,
    AvailableTimesStatus? timesStatus,
    List<String>? availableTimes,
    ValueGetter<String?>? selectedTime,
    bool? isSubmitting,
  }) {
    return AddSessionState(
      title: title ?? this.title,
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: selectedDate != null ? selectedDate() : this.selectedDate,
      timesStatus: timesStatus ?? this.timesStatus,
      availableTimes: availableTimes ?? this.availableTimes,
      selectedTime: selectedTime != null ? selectedTime() : this.selectedTime,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
        title,
        focusedMonth,
        selectedDate,
        timesStatus,
        availableTimes,
        selectedTime,
        isSubmitting,
      ];
}