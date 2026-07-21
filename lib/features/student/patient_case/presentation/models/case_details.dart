import '../../../../../core/widgets/status_badge.dart';
import 'diagnostic_media_item.dart';
import 'progress_phase.dart';
import 'supervisor_note.dart';
import 'treatment_plan.dart';

// Aggregate ui model for the case details screen.
// Fetched as one payload (separate from the patients list) once the backend
// is ready — edit fields to match the API contract then.
class CaseDetails {
  const CaseDetails({
    required this.patientId,
    required this.patientName,
    required this.status,
    required this.age,
    required this.nextSession,
    required this.subject,
    required this.supervisor,
    required this.planRows,
    required this.materials,
    required this.phases,
    required this.media,
    required this.notes,
  });

  final String patientId;
  final String patientName;
  final PatientStatus status;
  final int age;
  final String nextSession;
  final String subject;
  final String supervisor;
  final List<TreatmentPlanRow> planRows;
  final List<String> materials;
  final List<ProgressPhase> phases;
  final List<DiagnosticMediaItem> media;
  final List<SupervisorNote> notes;
}