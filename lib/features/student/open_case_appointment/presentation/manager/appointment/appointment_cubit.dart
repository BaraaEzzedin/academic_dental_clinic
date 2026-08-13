import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../patient_case/presentation/manager/add_session/add_session_state.dart'
    show AvailableTimesStatus;
import '../../../domain/use_cases/book_appointment_use_case.dart';
import '../../../domain/use_cases/get_available_appointments_use_case.dart';
import 'appointment_state.dart';

/// Drives the open-case "Book Appointment" sheet: month navigation, day
/// selection (which loads the available times), time selection and submit.
class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit({
    required GetAvailableAppointmentsUseCase getAvailableAppointments,
    required BookAppointmentUseCase bookAppointment,
    required this.clinicalCaseId,
    required this.subjectId,
    DateTime? initialMonth,
  })  : _getAvailableAppointments = getAvailableAppointments,
        _bookAppointment = bookAppointment,
        super(
          AppointmentState(
            focusedMonth: _monthStart(initialMonth ?? DateTime.now()),
          ),
        );

  final GetAvailableAppointmentsUseCase _getAvailableAppointments;
  final BookAppointmentUseCase _bookAppointment;
  final int clinicalCaseId;

  /// Drives the available-times query (availability is per subject, not per
  /// case), while [clinicalCaseId] is used when booking.
  final int subjectId;

  static DateTime _monthStart(DateTime date) => DateTime(date.year, date.month);

  void setTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void previousMonth() {
    final month = state.focusedMonth;
    emit(state.copyWith(focusedMonth: DateTime(month.year, month.month - 1)));
  }

  void nextMonth() {
    final month = state.focusedMonth;
    emit(state.copyWith(focusedMonth: DateTime(month.year, month.month + 1)));
  }

  Future<void> selectDate(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    emit(
      state.copyWith(
        selectedDate: () => normalized,
        selectedTime: () => null,
        supervisor: () => null,
        timesStatus: AvailableTimesStatus.loading,
        availableTimes: const [],
      ),
    );

    final result = await _getAvailableAppointments(
      GetAvailableAppointmentsParams(
        date: normalized,
        subjectId: subjectId,
      ),
    );

    // The user may have picked another day (or closed the sheet) while the
    // request was in flight; ignore stale responses.
    if (isClosed || state.selectedDate != normalized) return;

    result.fold(
      (failure) => emit(
        state.copyWith(timesStatus: AvailableTimesStatus.error),
      ),
      (appointments) => emit(
        state.copyWith(
          timesStatus: AvailableTimesStatus.loaded,
          availableTimes:
              appointments.slots.map((slot) => slot.startTime).toList(),
          supervisor: () => appointments.supervisor,
        ),
      ),
    );
  }

  void selectTime(String time) {
    emit(state.copyWith(selectedTime: () => time));
  }

  /// Books the appointment for the selected day/time. Returns `true` on
  /// success; on failure it stays open with [AppointmentState.submitError] set.
  Future<bool> submit() async {
    if (!state.canSubmit) return false;
    emit(state.copyWith(isSubmitting: true, submitError: () => null));

    final result = await _bookAppointment(
      BookAppointmentParams(
        clinicalCaseId: clinicalCaseId,
        date: state.selectedDate!,
        time: state.selectedTime!,
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