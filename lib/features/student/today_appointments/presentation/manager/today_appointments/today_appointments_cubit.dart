import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/get_today_appointments_use_case.dart';
import 'today_appointments_state.dart';

class TodayAppointmentsCubit extends Cubit<TodayAppointmentsState> {
  TodayAppointmentsCubit(this._getTodayAppointments)
      : super(const TodayAppointmentsState());

  final GetTodayAppointmentsUseCase _getTodayAppointments;

  Future<void> loadAppointments() async {
    emit(state.copyWith(status: TodayAppointmentsStatus.loading));
    final result = await _getTodayAppointments();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TodayAppointmentsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (schedule) => emit(
        state.copyWith(
          status: TodayAppointmentsStatus.loaded,
          schedule: schedule,
        ),
      ),
    );
  }
}