import '../../domain/entities/student_schedule_entity.dart';
import 'today_appointment_model.dart';

class StudentScheduleModel extends StudentScheduleEntity {
  const StudentScheduleModel({
    required super.today,
    required super.upcoming,
  });

  /// Builds the schedule from the node that holds the `today` / `upcoming`
  /// lists, exactly as grouped by the backend.
  factory StudentScheduleModel.fromJson(Map<String, dynamic> json) {
    return StudentScheduleModel(
      today: _parseGroup(json['today']),
      upcoming: _parseGroup(json['upcoming']),
    );
  }

  static List<AppointmentModel> _parseGroup(dynamic value) {
    final list = value as List<dynamic>? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(AppointmentModel.fromJson)
        .toList();
  }
}