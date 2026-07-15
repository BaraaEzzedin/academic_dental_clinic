enum ScheduleStatus { last, now, next, upcoming }

// model for ui , edit when backend is ready
class ScheduleItem {
  const ScheduleItem({
    required this.patientName,
    required this.subject,
    required this.clinic,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  final String patientName;
  final String subject;
  final String clinic;
  final String startTime;
  final String endTime;
  final ScheduleStatus status;
}