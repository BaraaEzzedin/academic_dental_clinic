import 'package:equatable/equatable.dart';

import 'today_appointment_entity.dart';

/// The student's schedule as grouped by the backend into `today` and
/// `upcoming`. The grouping is used as-is; the client never regroups it.
class StudentScheduleEntity extends Equatable {
  const StudentScheduleEntity({
    required this.today,
    required this.upcoming,
  });

  final List<AppointmentEntity> today;
  final List<AppointmentEntity> upcoming;

  /// True only when there is nothing to show in either group.
  bool get isEmpty => today.isEmpty && upcoming.isEmpty;

  @override
  List<Object?> get props => [today, upcoming];
}