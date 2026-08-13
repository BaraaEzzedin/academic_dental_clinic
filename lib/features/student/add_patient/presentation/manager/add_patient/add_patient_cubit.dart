import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/utils/date_formatter.dart';
import '../../../../case_acceptance_request/domain/entities/available_procedure_entity.dart';
import '../../../../case_acceptance_request/domain/entities/procedure_request_entity.dart';
import '../../../../case_acceptance_request/domain/entities/question_answer_entity.dart';
import '../../../../case_acceptance_request/domain/use_cases/get_subject_configuration_use_case.dart';
import '../../../../clinical_courses/domain/use_cases/get_clinical_courses_use_case.dart';
import '../../../../open_case_appointment/domain/use_cases/get_available_appointments_use_case.dart';
import '../../../../patient_case/presentation/manager/add_session/add_session_state.dart'
    show AvailableTimesStatus;
import '../../../domain/entities/patient_info_entity.dart';
import '../../../domain/entities/walk_in_request_entity.dart';
import '../../../domain/use_cases/create_walk_in_case_use_case.dart';
import 'add_patient_state.dart';

/// Orchestrates the whole 3-step Add Patient (walk-in) flow: patient info,
/// subject-driven case info + images, appointment, and the final multipart
/// submission.
class AddPatientCubit extends Cubit<AddPatientState> {
  AddPatientCubit({
    required GetClinicalCoursesUseCase getSubjects,
    required GetSubjectConfigurationUseCase getSubjectConfiguration,
    required GetAvailableAppointmentsUseCase getAvailableAppointments,
    required CreateWalkInCaseUseCase createWalkInCase,
    ImagePicker? imagePicker,
  })  : _getSubjects = getSubjects,
        _getSubjectConfiguration = getSubjectConfiguration,
        _getAvailableAppointments = getAvailableAppointments,
        _createWalkInCase = createWalkInCase,
        _imagePicker = imagePicker ?? ImagePicker(),
        super(AddPatientState());

  final GetClinicalCoursesUseCase _getSubjects;
  final GetSubjectConfigurationUseCase _getSubjectConfiguration;
  final GetAvailableAppointmentsUseCase _getAvailableAppointments;
  final CreateWalkInCaseUseCase _createWalkInCase;
  final ImagePicker _imagePicker;

  // ---------- Step navigation ----------
  void nextStep() {
    if (!state.canGoNext || state.currentStep >= 2) return;
    emit(state.copyWith(currentStep: state.currentStep + 1));
  }

  void previousStep() {
    if (state.currentStep == 0) return;
    emit(state.copyWith(currentStep: state.currentStep - 1));
  }

  // ---------- Step 1 ----------
  void setPatientInfo(PatientInfoEntity info) {
    emit(state.copyWith(patientInfo: info));
  }

  // ---------- Step 2: subjects ----------
  Future<void> loadSubjects({bool force = false}) async {
    if (!force &&
        (state.subjectsStatus == SubjectsStatus.loaded ||
            state.subjectsStatus == SubjectsStatus.loading)) {
      return;
    }
    emit(state.copyWith(subjectsStatus: SubjectsStatus.loading));
    final result = await _getSubjects();
    result.fold(
      (failure) => emit(state.copyWith(
        subjectsStatus: SubjectsStatus.error,
        subjectsError: failure.message,
      )),
      (subjects) => emit(state.copyWith(
        subjectsStatus: SubjectsStatus.loaded,
        subjects: subjects,
      )),
    );
  }

  void selectSubject(int subjectId) {
    if (subjectId == state.selectedSubjectId) return;
    // Switching subject invalidates the previously planned procedures.
    emit(state.copyWith(
      selectedSubjectId: () => subjectId,
      requests: const [],
      config: () => null,
      configStatus: ConfigStatus.loading,
    ));
    _loadConfiguration(subjectId);
  }

  Future<void> reloadConfiguration() async {
    final id = state.selectedSubjectId;
    if (id == null) return;
    emit(state.copyWith(configStatus: ConfigStatus.loading));
    await _loadConfiguration(id);
  }

  Future<void> _loadConfiguration(int subjectId) async {
    final result = await _getSubjectConfiguration(subjectId);
    if (isClosed || state.selectedSubjectId != subjectId) return;
    result.fold(
      (failure) => emit(state.copyWith(
        configStatus: ConfigStatus.error,
        configError: failure.message,
      )),
      (config) => emit(state.copyWith(
        configStatus: ConfigStatus.loaded,
        config: () => config,
      )),
    );
  }

  // ---------- Step 2: planned procedures ----------
  void saveProcedureRequest({
    int? toothNumber,
    String? existingId,
    required AvailableProcedureEntity procedure,
    required List<QuestionAnswerEntity> answers,
    required String notes,
  }) {
    final localId = existingId ??
        (toothNumber != null ? 'tooth-$toothNumber' : _generateLocalId());

    final request = ProcedureRequestEntity(
      localId: localId,
      toothNumber: toothNumber,
      procedureId: procedure.id,
      procedureName: procedure.name,
      notes: notes.trim(),
      answers: answers,
    );

    final updated = [...state.requests];
    final index = updated.indexWhere((r) => r.localId == localId);
    if (index >= 0) {
      updated[index] = request;
    } else {
      updated.add(request);
    }
    emit(state.copyWith(requests: updated));
  }

  void removeRequest(String localId) {
    if (!state.requests.any((r) => r.localId == localId)) return;
    emit(state.copyWith(
      requests: state.requests.where((r) => r.localId != localId).toList(),
    ));
  }

  // ---------- Step 2: case images ----------
  Future<void> pickImagesFromGallery() async {
    final files = await _imagePicker.pickMultiImage(imageQuality: 80);
    if (files.isEmpty) return;
    _appendImages(files.map((f) => f.path));
  }

  Future<void> captureImage() async {
    final file = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (file == null) return;
    _appendImages([file.path]);
  }

  void removeImage(String path) {
    if (!state.imagePaths.contains(path)) return;
    emit(state.copyWith(
      imagePaths: state.imagePaths.where((p) => p != path).toList(),
    ));
  }

  void _appendImages(Iterable<String> paths) {
    final merged = [...state.imagePaths];
    for (final p in paths) {
      if (!merged.contains(p)) merged.add(p);
    }
    emit(state.copyWith(imagePaths: merged));
  }

  // ---------- Step 3: appointment ----------
  void previousMonth() {
    final m = state.focusedMonth;
    emit(state.copyWith(focusedMonth: DateTime(m.year, m.month - 1)));
  }

  void nextMonth() {
    final m = state.focusedMonth;
    emit(state.copyWith(focusedMonth: DateTime(m.year, m.month + 1)));
  }

  Future<void> selectDate(DateTime date) async {
    final subjectId = state.selectedSubjectId;
    if (subjectId == null) return;
    final normalized = DateTime(date.year, date.month, date.day);
    emit(state.copyWith(
      selectedDate: () => normalized,
      selectedTime: () => null,
      timesStatus: AvailableTimesStatus.loading,
      availableTimes: const [],
    ));

    final result = await _getAvailableAppointments(
      GetAvailableAppointmentsParams(date: normalized, subjectId: subjectId),
    );

    // Ignore stale responses if the user changed the day meanwhile.
    if (isClosed || state.selectedDate != normalized) return;

    result.fold(
      (failure) => emit(state.copyWith(timesStatus: AvailableTimesStatus.error)),
      (appointments) => emit(state.copyWith(
        timesStatus: AvailableTimesStatus.loaded,
        availableTimes:
            appointments.slots.map((slot) => slot.startTime).toList(),
      )),
    );
  }

  void selectTime(String time) {
    emit(state.copyWith(selectedTime: () => time));
  }

  // ---------- Submission ----------
  Future<void> submit() async {
    if (!state.canSubmit) return;
    emit(state.copyWith(submission: WalkInSubmission.submitting));

    final request = WalkInRequestEntity(
      patientInfo: state.patientInfo,
      subjectId: state.selectedSubjectId!,
      plannedProcedures: state.orderedRequests,
      appointmentDate: DateFormatter.toIsoDate(state.selectedDate!),
      appointmentStart: state.selectedTime!,
      imagePaths: state.imagePaths,
    );

    final result = await _createWalkInCase(request);
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(
        submission: WalkInSubmission.failure,
        submissionError: failure.message,
      )),
      (_) => emit(state.copyWith(submission: WalkInSubmission.success)),
    );
  }

  String _generateLocalId() => DateTime.now().microsecondsSinceEpoch.toString();
}
