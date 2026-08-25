import 'package:equatable/equatable.dart';

/// A single available appointment slot returned by the backend, e.g. a
/// two-hour window from [startTime] to [endTime] (both `HH:mm`).
class AppointmentSlotEntity extends Equatable {
  const AppointmentSlotEntity({
    required this.startTime,
    required this.endTime,
  });

  final String startTime;
  final String endTime;

  @override
  List<Object?> get props => [startTime, endTime];
}