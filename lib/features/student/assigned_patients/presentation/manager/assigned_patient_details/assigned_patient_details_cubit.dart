import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/assigned_patient_details_entity.dart';
import '../../../domain/entities/assigned_patient_entity.dart';
import 'assigned_patient_details_state.dart';

class AssignedPatientDetailsCubit extends Cubit<AssignedPatientDetailsState> {
  AssignedPatientDetailsCubit() : super(const AssignedPatientDetailsState());

  /// Loads the full details for [patient].
  ///
  /// TODO(backend): replace the mock builder with a
  /// `GetAssignedPatientDetailsUseCase(patient.id)` call once the API is ready.
  /// The list already hands us the patient name, subject, chief complaint and
  /// appointment date, so those stay consistent between the list card and this
  /// screen.
  Future<void> load(AssignedPatientEntity patient) async {
    emit(state.copyWith(status: AssignedPatientDetailsStatus.loading));
    try {
      // Simulated network latency so the loading state is visible with mocks.
      await Future<void>.delayed(const Duration(milliseconds: 600));
      emit(
        state.copyWith(
          status: AssignedPatientDetailsStatus.loaded,
          details: _mock(patient),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AssignedPatientDetailsStatus.error,
          errorMessage: 'Could not load patient details. Please try again.',
        ),
      );
    }
  }

  /// Sends the case-acceptance request to the supervisor.
  ///
  /// TODO(backend): replace with a `SubmitCaseAcceptanceRequestUseCase(id)` call
  /// once the API is ready.
  Future<void> submitAcceptanceRequest() async {
    if (state.isSubmitting || state.details == null) return;
    emit(state.copyWith(submission: RequestSubmission.submitting));
    try {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      emit(state.copyWith(submission: RequestSubmission.success));
    } catch (_) {
      emit(state.copyWith(submission: RequestSubmission.failure));
    }
  }

  // Mock data for the UI — delete when the backend is ready. The identifying
  // fields come straight from the list entity so nothing drifts between screens.
  AssignedPatientDetailsEntity _mock(AssignedPatientEntity patient) {
    return AssignedPatientDetailsEntity(
      id: patient.id,
      patientName: patient.patientName,
      subjectName: patient.subjectName,
      chiefComplaint: patient.chiefComplaint,
      appointmentDate: patient.appointmentDate,
      appointmentTime: '10:30 AM',
      age: 29,
      gender: 'Female',
      phoneNumber: '+961 71 234 567',
      clinic: 'Clinic 3',
      symptoms: const [
        'Sharp pain when biting down',
        'Sensitivity to cold that lingers',
        'Mild swelling around the gum line',
      ],
      currentMedications: const [
        'Ibuprofen 400mg (as needed)',
      ],
      medicalConditions: const [
        'Hypertension (controlled)',
      ],
      allergies: const [
        'Penicillin',
      ],
    );
  }
}