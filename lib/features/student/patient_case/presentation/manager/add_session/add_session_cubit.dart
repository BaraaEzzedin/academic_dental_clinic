import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../open_case_appointment/domain/use_cases/get_available_appointments_use_case.dart';
import '../../../domain/use_cases/create_treatment_session_use_case.dart';
import 'add_session_state.dart';

/// Drives the "Add New Session" sheet: month navigation, day selection (which
/// loads the available times for the subject), time selection and submit.
class AddSessionCubit extends Cubit<AddSessionState> {
  AddSessionCubit({
    required GetAvailableAppointmentsUseCase getAvailableAppointments,
    required CreateTreatmentSessionUseCase createTreatmentSession,
    required this.clinicalCaseId,
    required this.subjectId,
    required bool isFirstSession,
    DateTime? initialMonth,
  })  : _getAvailableAppointments = getAvailableAppointments,
        _createTreatmentSession = createTreatmentSession,
        super(
          AddSessionState(
            isFirstSession: isFirstSession,
            focusedMonth: _monthStart(initialMonth ?? DateTime.now()),
          ),
        );

  final GetAvailableAppointmentsUseCase _getAvailableAppointments;
  final CreateTreatmentSessionUseCase _createTreatmentSession;

  /// The session is created against the case.
  final int clinicalCaseId;

  /// Availability is queried per subject, not per case.
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
        timesStatus: AvailableTimesStatus.loading,
        availableTimes: const [],
      ),
    );

    final result = await _getAvailableAppointments(
      GetAvailableAppointmentsParams(date: normalized, subjectId: subjectId),
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
        ),
      ),
    );
  }

  void selectTime(String time) {
    emit(state.copyWith(selectedTime: () => time));
  }

  /// Creates the treatment session for the selected day/time. Returns `true`
  /// on success; on failure it stays open with [AddSessionState.submitError].
  Future<bool> submit() async {
    if (!state.canSubmit) return false;
    emit(state.copyWith(isSubmitting: true, submitError: () => null));

    final result = await _createTreatmentSession(
      CreateTreatmentSessionParams(
        clinicalCaseId: clinicalCaseId,
        title: state.title.trim(),
        // The first session carries no appointment; only case id + title.
        appointmentDate: state.isFirstSession ? null : state.selectedDate,
        appointmentStart: state.isFirstSession ? null : state.selectedTime,
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