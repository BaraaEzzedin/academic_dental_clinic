import '../../domain/entities/supervisor_note_entity.dart';

class SupervisorNoteModel extends SupervisorNoteEntity {
  const SupervisorNoteModel({
    required super.supervisor,
    required super.sessionTitle,
    required super.notes,
    super.createdAt,
  });

  factory SupervisorNoteModel.fromJson(Map<String, dynamic> json) {
    return SupervisorNoteModel(
      supervisor: json['supervisor'] as String? ?? '',
      sessionTitle: json['sessionTitle'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
    );
  }
}
