import 'package:equatable/equatable.dart';

/// One entry of the progress `timeline`, e.g.
/// "Class II composite restoration — tooth 46", "completed", 21 Jun 2026.
class TimelineEntryEntity extends Equatable {
  const TimelineEntryEntity({
    required this.title,
    this.rawStatus,
    this.date,
  });

  final String title;
  final String? rawStatus;
  final DateTime? date;

  @override
  List<Object?> get props => [title, rawStatus, date];
}
