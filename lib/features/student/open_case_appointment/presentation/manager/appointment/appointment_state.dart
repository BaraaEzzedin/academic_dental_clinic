import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../../patient_case/presentation/manager/add_session/add_session_state.dart'
    show AvailableTimesStatus;

/// Default title for an open-case appointment. The appointment flow always
/// starts as an "Initial Examination" (the student is booking the first visit
/// for a case they are about to take), but the title stays editable.
const String kInitialExaminationTitle = 'Initial Examination';

/// State for the "Book Appointment" bottom sheet on the open-case flow.
///
/// Mirrors the "Add New Session" sheet (same calendar + available-times UX),
/// with the title pre-filled to [kInitialExaminationTitle].
class AppointmentState extends Equatable {
  const AppointmentState({
    required this.focusedMonth,
    this.title = kInitialExaminationTitle,
    this.selectedDate,
    this.timesStatus = AvailableTimesStatus.initial,
    this.availableTimes = const [],
    this.selectedTime,
    this.supervisor,
    this.isSubmitting = false,
    this.submitError,
  });

  final String title;
  final DateTime focusedMonth;
  final DateTime? selectedDate;
  final AvailableTimesStatus timesStatus;
  final List<String> availableTimes;
  final String? selectedTime;

  /// Supervising doctor for the selected day, from the available-slots API.
  final String? supervisor;
  final bool isSubmitting;

  /// Error message from the last booking attempt, null when there is none.
  final String? submitError;

  bool get canSubmit =>
      title.trim().isNotEmpty &&
      selectedDate != null &&
      selectedTime != null &&
      !isSubmitting;

  AppointmentState copyWith({
    String? title,
    DateTime? focusedMonth,
    ValueGetter<DateTime?>? selectedDate,
    AvailableTimesStatus? timesStatus,
    List<String>? availableTimes,
    ValueGetter<String?>? selectedTime,
    ValueGetter<String?>? supervisor,
    bool? isSubmitting,
    ValueGetter<String?>? submitError,
  }) {
    return AppointmentState(
      title: title ?? this.title,
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: selectedDate != null ? selectedDate() : this.selectedDate,
      timesStatus: timesStatus ?? this.timesStatus,
      availableTimes: availableTimes ?? this.availableTimes,
      selectedTime: selectedTime != null ? selectedTime() : this.selectedTime,
      supervisor: supervisor != null ? supervisor() : this.supervisor,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: submitError != null ? submitError() : this.submitError,
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
        supervisor,
        isSubmitting,
        submitError,
      ];
}