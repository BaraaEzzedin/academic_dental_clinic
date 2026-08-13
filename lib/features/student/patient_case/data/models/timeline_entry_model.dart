import '../../domain/entities/timeline_entry_entity.dart';

class TimelineEntryModel extends TimelineEntryEntity {
  const TimelineEntryModel({
    required super.title,
    super.rawStatus,
    super.date,
  });

  factory TimelineEntryModel.fromJson(Map<String, dynamic> json) {
    return TimelineEntryModel(
      title: json['title'] as String? ?? '',
      rawStatus: json['status'] as String?,
      date: DateTime.tryParse(json['date'] as String? ?? ''),
    );
  }
}
