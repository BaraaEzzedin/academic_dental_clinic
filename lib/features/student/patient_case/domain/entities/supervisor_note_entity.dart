import 'package:equatable/equatable.dart';

/// A supervisor note from `supervisorNotes`.
class SupervisorNoteEntity extends Equatable {
  const SupervisorNoteEntity({
    required this.supervisor,
    required this.sessionTitle,
    required this.notes,
    this.createdAt,
  });

  final String supervisor;
  final String sessionTitle;
  final String notes;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [supervisor, sessionTitle, notes, createdAt];
}
