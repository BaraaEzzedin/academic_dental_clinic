import '../../../../../core/utils/date_formatter.dart';
import '../../domain/entities/treatment_session_entity.dart';
import '../models/session.dart';

/// Maps the backend session status string to the presentation [SessionStatus].
/// The backend returns exactly `active` / `upcoming` / `completed`.
SessionStatus sessionStatusFromApi(String? value) {
  return switch (value?.toLowerCase()) {
    'active' => SessionStatus.active,
    'upcoming' => SessionStatus.upcoming,
    'completed' => SessionStatus.completed,
    _ => SessionStatus.upcoming,
  };
}

/// Adapts a domain [TreatmentSessionEntity] to the [Session] UI model consumed
/// by the existing session widgets. The sessions endpoint doesn't return the
/// per-tooth checklist/treatment items, so those stay empty for now.
Session sessionFromEntity(TreatmentSessionEntity entity) {
  final date = entity.appointmentDate;
  return Session(
    id: entity.id,
    title: entity.title,
    date: date != null ? DateFormatter.toMediumDate(date) : '',
    time: DateFormatter.toTimeOfDay(entity.startTime),
    appointmentDate: date,
    startTimeRaw: entity.startTime,
    status: sessionStatusFromApi(entity.rawStatus),
    items: const [],
    note: entity.notes.isEmpty ? null : entity.notes,
  );
}