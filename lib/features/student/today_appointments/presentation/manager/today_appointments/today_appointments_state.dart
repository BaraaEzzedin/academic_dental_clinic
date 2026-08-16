import 'package:equatable/equatable.dart';
import '../../../domain/entities/student_schedule_entity.dart';
import '../../../domain/entities/today_appointment_entity.dart';

enum TodayAppointmentsStatus { initial, loading, loaded, error }

class TodayAppointmentsState extends Equatable {
  const TodayAppointmentsState({
    this.status = TodayAppointmentsStatus.initial,
    this.schedule,
    this.errorMessage,
  });

  final TodayAppointmentsStatus status;
  final StudentScheduleEntity? schedule;
  final String? errorMessage;

  bool get isLoading => status == TodayAppointmentsStatus.loading;
  bool get hasError => status == TodayAppointmentsStatus.error;

  List<AppointmentEntity> get today => schedule?.today ?? const [];
  List<AppointmentEntity> get upcoming => schedule?.upcoming ?? const [];

  /// Loaded, but neither group has any appointments.
  bool get isEmpty =>
      status == TodayAppointmentsStatus.loaded &&
      (schedule == null || schedule!.isEmpty);

  TodayAppointmentsState copyWith({
    TodayAppointmentsStatus? status,
    StudentScheduleEntity? schedule,
    String? errorMessage,
  }) {
    return TodayAppointmentsState(
      status: status ?? this.status,
      schedule: schedule ?? this.schedule,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, schedule, errorMessage];
}