import 'package:equatable/equatable.dart';
import 'appointment_slot_entity.dart';

/// Available appointment slots for a given date and clinical case, along with
/// the supervising doctor for that day.
class AvailableAppointmentsEntity extends Equatable {
  const AvailableAppointmentsEntity({
    required this.supervisor,
    required this.appointmentDate,
    required this.slots,
  });

  final String supervisor;
  final DateTime? appointmentDate;
  final List<AppointmentSlotEntity> slots;

  @override
  List<Object?> get props => [supervisor, appointmentDate, slots];
}