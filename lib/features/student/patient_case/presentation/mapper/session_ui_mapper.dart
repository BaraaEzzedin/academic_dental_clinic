import '../../../../../core/utils/date_formatter.dart';
import '../../domain/entities/treatment_session_entity.dart';
import '../models/session.dart';

/// Maps the backend session status string to the presentation [SessionStatus].
SessionStatus sessionStatusFromApi(String? value) {
  return switch (value?.toUpperCase()) {
    'COMPLETED' => SessionStatus.completed,
    'IN_PROGRESS' => SessionStatus.inProgress,
    'PLANNED' => SessionStatus.planned,
    _ => SessionStatus.planned,
  };
}

/// Adapts a domain [TreatmentSessionEntity] to the [Session] UI model consumed
/// by the existing session widgets. The sessions endpoint doesn't return the
/// per-tooth checklist/treatment items, so those stay empty for now.
Session sessionFromEntity(TreatmentSessionEntity entity) {
  final date = entity.appointmentDate;
  return Session(
    title: entity.title,
    date: date != null ? DateFormatter.toMediumDate(date) : '',
    status: sessionStatusFromApi(entity.rawStatus),
    items: const [],
    note: entity.notes.isEmpty ? null : entity.notes,
  );
}