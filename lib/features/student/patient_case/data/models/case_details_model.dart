import '../../domain/entities/case_details_entity.dart';
import 'case_info_model.dart';
import 'case_media_model.dart';
import 'planned_procedure_model.dart';
import 'supervisor_note_model.dart';
import 'timeline_entry_model.dart';

class CaseDetailsModel extends CaseDetailsEntity {
  const CaseDetailsModel({
    required super.caseInfo,
    required super.targetTeeth,
    required super.materials,
    required super.media,
    required super.timeline,
    required super.supervisorNotes,
  });

  factory CaseDetailsModel.fromJson(Map<String, dynamic> json) {
    final caseInfo = json['caseInfo'] as Map<String, dynamic>? ?? const {};
    final treatmentPlan =
        json['treatmentPlan'] as Map<String, dynamic>? ?? const {};
    final targetTeeth = treatmentPlan['targetTeeth'] as List<dynamic>? ?? const [];
    final materials = json['materials'] as List<dynamic>? ?? const [];
    final media = json['caseMedia'] as List<dynamic>? ?? const [];
    final timeline = json['timeline'] as List<dynamic>? ?? const [];
    final notes = json['supervisorNotes'] as List<dynamic>? ?? const [];

    return CaseDetailsModel(
      caseInfo: CaseInfoModel.fromJson(caseInfo),
      targetTeeth: targetTeeth
          .whereType<Map<String, dynamic>>()
          .map(PlannedProcedureModel.fromJson)
          .toList(),
      materials: materials.map(_materialName).toList(),
      media: media
          .whereType<Map<String, dynamic>>()
          .map(CaseMediaModel.fromJson)
          .toList(),
      timeline: timeline
          .whereType<Map<String, dynamic>>()
          .map(TimelineEntryModel.fromJson)
          .toList(),
      supervisorNotes: notes
          .whereType<Map<String, dynamic>>()
          .map(SupervisorNoteModel.fromJson)
          .toList(),
    );
  }

  /// Materials may arrive as plain strings or `{ "name": ... }` objects.
  static String _materialName(dynamic entry) {
    if (entry is String) return entry;
    if (entry is Map<String, dynamic>) return entry['name'] as String? ?? '';
    return entry.toString();
  }
}
