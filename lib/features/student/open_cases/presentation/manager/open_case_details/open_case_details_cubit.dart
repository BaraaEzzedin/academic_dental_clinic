import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/open_case_details_entity.dart';
import '../../../domain/entities/open_case_entity.dart';
import 'open_case_details_state.dart';

class OpenCaseDetailsCubit extends Cubit<OpenCaseDetailsState> {
  OpenCaseDetailsCubit() : super(const OpenCaseDetailsState());

  /// Loads the full details for [openCase].
  ///
  /// TODO(backend): replace the mock builder with a
  /// `GetOpenCaseDetailsUseCase(openCase.id)` call once the API is ready. The
  /// list already hands us the patient name, subject and chief complaint, so
  /// those stay consistent between the list card and this screen.
  Future<void> load(OpenCaseEntity openCase) async {
    emit(state.copyWith(status: OpenCaseDetailsStatus.loading));
    try {
      // Simulated network latency so the loading state is visible with mocks.
      await Future<void>.delayed(const Duration(milliseconds: 600));
      emit(
        state.copyWith(
          status: OpenCaseDetailsStatus.loaded,
          details: _mock(openCase),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: OpenCaseDetailsStatus.error,
          errorMessage: 'Could not load case details. Please try again.',
        ),
      );
    }
  }

  // Mock data for the UI — delete when the backend is ready. The identifying
  // fields come straight from the list entity so nothing drifts between screens.
  OpenCaseDetailsEntity _mock(OpenCaseEntity openCase) {
    return OpenCaseDetailsEntity(
      id: openCase.id,
      patientName: openCase.patientName,
      subject: openCase.subject,
      chiefComplaint: openCase.chiefComplaint,
      age: 34,
      gender: 'Female',
      phoneNumber: '+961 71 234 567',
      symptoms: const [
        'Sharp pain when biting down',
        'Sensitivity to cold that lingers',
        'Mild swelling around the gum line',
      ],
      currentMedications: const [
        'Ibuprofen 400mg (as needed)',
        'Amoxicillin 500mg',
      ],
      allergies: const [
        'Penicillin',
        'Latex',
      ],
      media: const [
        CaseMediaEntity(label: 'PANOREX', date: '10/07/26'),
        CaseMediaEntity(label: 'PERIAPICAL', date: '10/07/26'),
        CaseMediaEntity(label: 'INTRAORAL', date: '10/07/26'),
      ],
    );
  }
}