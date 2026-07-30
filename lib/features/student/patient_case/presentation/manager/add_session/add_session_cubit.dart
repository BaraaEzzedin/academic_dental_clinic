import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_session_state.dart';

class AddSessionCubit extends Cubit<AddSessionState> {
  AddSessionCubit({DateTime? initialMonth})
      : super(
          AddSessionState(
            focusedMonth: _monthStart(initialMonth ?? DateTime.now()),
          ),
        );

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

    // TODO(backend): replace with repository.fetchAvailableTimes(normalized).
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (isClosed || state.selectedDate != normalized) return;

    emit(
      state.copyWith(
        timesStatus: AvailableTimesStatus.loaded,
        availableTimes: _mockTimes(normalized),
      ),
    );
  }

  void selectTime(String time) {
    emit(state.copyWith(selectedTime: () => time));
  }


  Future<void> submit() async {
    if (!state.canSubmit) return;
    emit(state.copyWith(isSubmitting: true));
    // TODO(backend): await repository.createSession(date, time, ...).
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (isClosed) return;
    emit(state.copyWith(isSubmitting: false));
  }

  // mock available slots for ui , delete when backend is ready
  List<String> _mockTimes(DateTime date) {
    const all = [
      '09:00 AM',
      '10:30 AM',
      '12:00 PM',
      '01:30 PM',
      '03:00 PM',
      '04:30 PM',
    ];
    final count = 3 + (date.day % 3);
    return all.take(count).toList();
  }
}