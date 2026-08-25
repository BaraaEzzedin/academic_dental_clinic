import '../../domain/entities/appointment_slot_entity.dart';
import '../../domain/entities/available_appointments_entity.dart';

class AppointmentSlotModel extends AppointmentSlotEntity {
  const AppointmentSlotModel({
    required super.startTime,
    required super.endTime,
  });

  factory AppointmentSlotModel.fromJson(Map<String, dynamic> json) {
    return AppointmentSlotModel(
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
    );
  }
}

class AvailableAppointmentsModel extends AvailableAppointmentsEntity {
  const AvailableAppointmentsModel({
    required super.supervisor,
    required super.appointmentDate,
    required super.slots,
  });

  factory AvailableAppointmentsModel.fromJson(Map<String, dynamic> json) {
    final slots = json['slots'] as List<dynamic>? ?? const [];
    return AvailableAppointmentsModel(
      supervisor: json['supervisor'] as String? ?? '',
      appointmentDate:
          DateTime.tryParse(json['appointmentDate'] as String? ?? ''),
      slots: slots
          .map((e) => AppointmentSlotModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}