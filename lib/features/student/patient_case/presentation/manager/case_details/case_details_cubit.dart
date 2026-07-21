import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/widgets/status_badge.dart';
import '../../models/case_details.dart';
import '../../models/diagnostic_media_item.dart';
import '../../models/progress_phase.dart';
import '../../models/supervisor_note.dart';
import '../../models/treatment_plan.dart';
import 'case_details_state.dart';

class CaseDetailsCubit extends Cubit<CaseDetailsState> {
  CaseDetailsCubit() : super(const CaseDetailsState());

  Future<void> load(String patientId) async {
    emit(state.copyWith(status: CaseDetailsStatus.loading));
    try {
      // TODO(backend): replace with repository.fetchCaseDetails(patientId).
      await Future<void>.delayed(const Duration(milliseconds: 400));
      emit(
        state.copyWith(
          status: CaseDetailsStatus.loaded,
          details: _mock(patientId),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CaseDetailsStatus.error,
          errorMessage: 'Could not load case details. Please try again.',
        ),
      );
    }
  }

  // mock data for ui , delete when backend is ready
  CaseDetails _mock(String patientId) {
    return CaseDetails(
      patientId: patientId,
      patientName: 'Ahmad Mohammad',
      status: PatientStatus.inTreatment,
      age: 28,
      nextSession: '15 / June',
      subject: 'Endodontics 2',
      supervisor: 'Dr. Kareem Karam',
      planRows: const [
        TreatmentPlanRow(tooth: 'Tooth #13', procedure: 'Endodontic Access'),
        TreatmentPlanRow(tooth: 'Tooth #23', procedure: 'Pulpectomy'),
      ],
      materials: const ['Zirconia', 'Gutta-percha', 'Composite Resin'],
      phases: const [
        ProgressPhase(
          title: 'First Phase',
          date: 'Aug 12, 2023',
          status: PhaseStatus.completed,
        ),
        ProgressPhase(
          title: 'Second Phase',
          date: 'Oct 04, 2023',
          status: PhaseStatus.upcoming,
        ),
      ],
      media: const [
        DiagnosticMediaItem(label: 'PANOREX', date: '10/07/26'),
        DiagnosticMediaItem(label: 'PERIAPICAL', date: '10/07/26'),
      ],
      notes: const [
        SupervisorNote(
          reviewer: 'Dr. Sarah Ahmad',
          session: 2,
          date: '10/07/26',
          timeAgo: '2h ago',
          message:
              'Excellent margin preparation on #14. Ensure the gingival '
              'retraction is maintained for at least 5 minutes prior to the '
              'final impression. Great progress.',
        ),
      ],
    );
  }
}