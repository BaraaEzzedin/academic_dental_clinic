import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../open_case_appointment/domain/use_cases/get_available_appointments_use_case.dart';
import '../../../domain/use_cases/edit_treatment_session_use_case.dart';
import '../add_session/add_session_state.dart' show AvailableTimesStatus;
import 'edit_schedule_state.dart';

/// Drives the "Edit Session" (reschedule) sheet for an upcoming session:
/// pre-fills the current title/date/time, loads available times, and submits
/// only the changed fields.
class EditScheduleCubit extends Cubit<EditScheduleState> {
  EditScheduleCubit({
    required GetAvailableAppointmentsUseCase getAvailableAppointments,
    required EditTreatmentSessionUseCase editSession,
    required this.treatmentSessionId,
    required this.subjectId,
    required String initialTitle,
    required DateTime? initialDate,
    required String initialTime,
  })  : _getAvailableAppointments = getAvailableAppointments,
        _editSession = editSession,
        super(
          EditScheduleState(
            focusedMonth: _monthStart(initialDate ?? DateTime.now()),
            originalTitle: initialTitle,
            originalDate: initialDate == null ? null : _dateOnly(initialDate),
            originalTime: initialTime,
            title: initialTitle,
            selectedDate: initialDate == null ? null : _dateOnly(initialDate),
            selectedTime: initialTime.isEmpty ? null : initialTime,
          ),
        );

  final GetAvailableAppointmentsUseCase _getAvailableAppointments;
  final EditTreatmentSessionUseCase _editSession;
  final int treatmentSessionId;
  final int subjectId;

  static DateTime _monthStart(DateTime date) => DateTime(date.year, date.month);
  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Loads the available times for the current (original) day, keeping the
  /// pre-selected time so an untouched schedule counts as unchanged.
  Future<void> init() async {
    final date = state.selectedDate;
    if (date == null) return;
    emit(state.copyWith(
      timesStatus: AvailableTimesStatus.loading,
      availableTimes: const [],
    ));
    final result = await _getAvailableAppointments(
      GetAvailableAppointmentsParams(date: date, subjectId: subjectId),
    );
    // Ignore a stale response if the user changed the day meanwhile.
    if (isClosed || state.selectedDate != date) return;
    result.fold(
      (_) => emit(state.copyWith(timesStatus: AvailableTimesStatus.error)),
      (appointments) => emit(state.copyWith(
        timesStatus: AvailableTimesStatus.loaded,
        availableTimes:
            appointments.slots.map((slot) => slot.startTime).toList(),
      )),
    );
  }

  void setTitle(String title) => emit(state.copyWith(title: title));

  void previousMonth() {
    final m = state.focusedMonth;
    emit(state.copyWith(focusedMonth: DateTime(m.year, m.month - 1)));
  }

  void nextMonth() {
    final m = state.focusedMonth;
    emit(state.copyWith(focusedMonth: DateTime(m.year, m.month + 1)));
  }

  Future<void> selectDate(DateTime date) async {
    final normalized = _dateOnly(date);
    emit(state.copyWith(
      selectedDate: () => normalized,
      selectedTime: () => null,
      timesStatus: AvailableTimesStatus.loading,
      availableTimes: const [],
    ));

    final result = await _getAvailableAppointments(
      GetAvailableAppointmentsParams(date: normalized, subjectId: subjectId),
    );

    if (isClosed || state.selectedDate != normalized) return;

    result.fold(
      (_) => emit(state.copyWith(timesStatus: AvailableTimesStatus.error)),
      (appointments) => emit(state.copyWith(
        timesStatus: AvailableTimesStatus.loaded,
        availableTimes:
            appointments.slots.map((slot) => slot.startTime).toList(),
      )),
    );
  }

  void selectTime(String time) =>
      emit(state.copyWith(selectedTime: () => time));

  /// Submits only the changed fields. Returns `true` on success; on failure it
  /// stays open with [EditScheduleState.submitError].
  Future<bool> submit() async {
    if (!state.canSubmit) return false;
    emit(state.copyWith(isSubmitting: true, submitError: () => null));

    final s = state;
    final result = await _editSession(
      EditSessionParams(
        treatmentSessionId: treatmentSessionId,
        title: s.titleChanged ? s.title.trim() : null,
        appointmentDate: s.scheduleChanged ? s.selectedDate : null,
        appointmentStart: s.scheduleChanged ? s.selectedTime : null,
      ),
    );

    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(state.copyWith(
          isSubmitting: false,
          submitError: () => failure.message,
        ));
        return false;
      },
      (_) {
        emit(state.copyWith(isSubmitting: false));
        return true;
      },
    );
  }
}
