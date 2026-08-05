import 'package:equatable/equatable.dart';

class TodayAppointmentEntity extends Equatable {
  const TodayAppointmentEntity({
    required this.id,
    required this.patientName,
    required this.start,
    required this.displayStatus,
  });

  final int id;
  final String patientName;
  final String start;
  final String displayStatus;

  @override
  List<Object?> get props => [id, patientName, start, displayStatus];
}