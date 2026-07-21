import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/widgets/status_badge.dart';
import '../../models/case_details.dart';
import '../../models/diagnostic_media_item.dart';
import '../../models/progress_phase.dart';
import '../../models/supervisor_note.dart';
import '../../models/tooth.dart';
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
      dentalChart: _mockChart(),
    );
  }

  // mock dental chart for ui , delete when backend is ready
  Map<int, ToothRecord> _mockChart() => {
        16: ToothRecord(procedures: [
          ProcedureRecord(
            type: ProcedureType.rootCanal,
            date: DateTime(2025, 11, 3),
            student: 'S. Mansour',
            supervisor: 'Dr. Verhoeven',
            approval: ApprovalStatus.completed,
            notes: 'Four canals located and obturated. Post-op radiograph '
                'shows adequate fill length; patient asymptomatic at review.',
          ),
          ProcedureRecord(
            type: ProcedureType.crown,
            date: DateTime(2026, 1, 21),
            student: 'S. Mansour',
            supervisor: 'Dr. Verhoeven',
            approval: ApprovalStatus.completed,
            notes: 'Full-ceramic crown cemented. Occlusion verified.',
          ),
        ]),
        26: ToothRecord(procedures: [
          ProcedureRecord(
            type: ProcedureType.compositeFilling,
            date: DateTime(2026, 6, 12),
            student: 'L. de Vries',
            supervisor: 'Dr. Okafor',
            approval: ApprovalStatus.pendingReview,
            notes: 'Class II MO cavity. Plan: composite restoration under '
                'rubber dam.',
          ),
        ]),
        11: ToothRecord(procedures: [
          ProcedureRecord(
            type: ProcedureType.veneer,
            date: DateTime(2026, 5, 2),
            student: 'L. de Vries',
            supervisor: 'Dr. Okafor',
            approval: ApprovalStatus.approved,
            notes: 'Approved for porcelain veneer; shade B1 agreed with '
                'patient.',
          ),
        ]),
        47: ToothRecord(procedures: [
          ProcedureRecord(
            type: ProcedureType.amalgamFilling,
            date: DateTime(2026, 4, 18),
            student: 'K. Haddad',
            supervisor: 'Dr. Verhoeven',
            approval: ApprovalStatus.rejected,
            notes: 'Rejected: insufficient caries removal on distal wall. '
                'Re-plan with updated cavity design and resubmit.',
          ),
        ]),
        36: ToothRecord(extracted: true, procedures: [
          ProcedureRecord(
            type: ProcedureType.extraction,
            date: DateTime(2025, 9, 14),
            student: 'K. Haddad',
            supervisor: 'Dr. Silva',
            approval: ApprovalStatus.completed,
            notes: 'Non-restorable due to vertical root fracture. '
                'Uncomplicated extraction; socket healing normal.',
          ),
          ProcedureRecord(
            type: ProcedureType.implant,
            date: DateTime(2026, 3, 9),
            student: 'K. Haddad',
            supervisor: 'Dr. Silva',
            approval: ApprovalStatus.approved,
            notes: 'Implant placement approved after CBCT evaluation.',
          ),
        ]),
        34: ToothRecord(procedures: [
          ProcedureRecord(
            type: ProcedureType.scalingPolishing,
            date: DateTime(2026, 2, 5),
            student: 'S. Mansour',
            supervisor: 'Dr. Okafor',
            approval: ApprovalStatus.completed,
          ),
          ProcedureRecord(
            type: ProcedureType.temporaryRestoration,
            date: DateTime(2026, 6, 20),
            student: 'S. Mansour',
            supervisor: 'Dr. Okafor',
            approval: ApprovalStatus.pendingReview,
            notes: 'Temporary restoration while awaiting definitive plan.',
          ),
        ]),
      };
}