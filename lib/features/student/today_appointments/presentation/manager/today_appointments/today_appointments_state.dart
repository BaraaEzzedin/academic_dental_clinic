import 'package:equatable/equatable.dart';
import '../../../domain/entities/today_appointment_entity.dart';

enum TodayAppointmentsStatus { initial, loading, loaded, error }

class TodayAppointmentsState extends Equatable {
  const TodayAppointmentsState({
    this.status = TodayAppointmentsStatus.initial,
    this.appointments = const [],
    this.errorMessage,
  });

  final TodayAppointmentsStatus status;
  final List<TodayAppointmentEntity> appointments;
  final String? errorMessage;

  bool get isLoading => status == TodayAppointmentsStatus.loading;
  bool get hasError => status == TodayAppointmentsStatus.error;
  bool get isEmpty =>
      status == TodayAppointmentsStatus.loaded && appointments.isEmpty;
  bool get hasAppointments =>
      status == TodayAppointmentsStatus.loaded && appointments.isNotEmpty;

  TodayAppointmentsState copyWith({
    TodayAppointmentsStatus? status,
    List<TodayAppointmentEntity>? appointments,
    String? errorMessage,
  }) {
    return TodayAppointmentsState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, appointments, errorMessage];
}