import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../case_acceptance_request/domain/entities/available_procedure_entity.dart';
import '../../../../case_acceptance_request/domain/entities/procedure_request_entity.dart';
import '../../../../case_acceptance_request/domain/entities/subject_config_entity.dart';
import '../../../../case_acceptance_request/domain/entities/subject_question_entity.dart';
import '../../../../clinical_courses/domain/entities/clinical_course_entity.dart';
import '../../../../patient_case/presentation/manager/add_session/add_session_state.dart'
    show AvailableTimesStatus;
import '../../../domain/entities/patient_info_entity.dart';

enum SubjectsStatus { initial, loading, loaded, error }

enum ConfigStatus { initial, loading, loaded, error }

enum WalkInSubmission { idle, submitting, success, failure }

class AddPatientState extends Equatable {
  AddPatientState({
    this.currentStep = 0,
    this.patientInfo = const PatientInfoEntity(),
    this.subjectsStatus = SubjectsStatus.initial,
    this.subjects = const [],
    this.subjectsError,
    this.selectedSubjectId,
    this.configStatus = ConfigStatus.initial,
    this.config,
    this.configError,
    this.requests = const [],
    this.imagePaths = const [],
    DateTime? focusedMonth,
    this.selectedDate,
    this.timesStatus = AvailableTimesStatus.initial,
    this.availableTimes = const [],
    this.selectedTime,
    this.submission = WalkInSubmission.idle,
    this.submissionError,
  }) : focusedMonth = focusedMonth ?? DateTime(DateTime.now().year, DateTime.now().month);

  final int currentStep;

  // Step 1
  final PatientInfoEntity patientInfo;

  // Step 2 — subject selection + configuration
  final SubjectsStatus subjectsStatus;
  final List<ClinicalCourseEntity> subjects;
  final String? subjectsError;
  final int? selectedSubjectId;
  final ConfigStatus configStatus;
  final SubjectConfigEntity? config;
  final String? configError;

  // Step 2 — planned procedures + case images
  final List<ProcedureRequestEntity> requests;
  final List<String> imagePaths;

  // Step 3 — appointment
  final DateTime focusedMonth;
  final DateTime? selectedDate;
  final AvailableTimesStatus timesStatus;
  final List<String> availableTimes;
  final String? selectedTime;

  // Submission
  final WalkInSubmission submission;
  final String? submissionError;

  bool get isLoadingSubjects =>
      subjectsStatus == SubjectsStatus.initial ||
      subjectsStatus == SubjectsStatus.loading;
  bool get hasSubjectsError => subjectsStatus == SubjectsStatus.error;

  bool get isLoadingConfig => configStatus == ConfigStatus.loading;
  bool get hasConfigError => configStatus == ConfigStatus.error;
  bool get hasConfig => configStatus == ConfigStatus.loaded && config != null;

  bool get requiresDentalChart => config?.requiresDentalChart ?? false;

  List<AvailableProcedureEntity> get procedures =>
      config?.availableProcedures ?? const [];
  List<SubjectQuestionEntity> get questions =>
      config?.orderedQuestions ?? const [];

  Set<int> get selectedTeeth => {
        for (final r in requests)
          if (r.toothNumber != null) r.toothNumber!,
      };

  List<ProcedureRequestEntity> get orderedRequests {
    if (!requiresDentalChart) return requests;
    final list = [...requests]
      ..sort((a, b) => (a.toothNumber ?? 0).compareTo(b.toothNumber ?? 0));
    return list;
  }

  ProcedureRequestEntity? requestForTooth(int toothNumber) {
    for (final r in requests) {
      if (r.toothNumber == toothNumber) return r;
    }
    return null;
  }

  bool get isSubmitting => submission == WalkInSubmission.submitting;

  // ---- Per-step validation ----
  bool get isStep1Valid => patientInfo.isComplete;

  bool get _teethAssigned =>
      !requiresDentalChart || requests.every((r) => r.toothNumber != null);

  bool get isStep2Valid =>
      selectedSubjectId != null && requests.isNotEmpty && _teethAssigned;

  bool get isStep3Valid => selectedDate != null && selectedTime != null;

  bool get canGoNext {
    switch (currentStep) {
      case 0:
        return isStep1Valid;
      case 1:
        return isStep2Valid;
      default:
        return true;
    }
  }

  bool get canSubmit =>
      isStep1Valid && isStep2Valid && isStep3Valid && !isSubmitting;

  AddPatientState copyWith({
    int? currentStep,
    PatientInfoEntity? patientInfo,
    SubjectsStatus? subjectsStatus,
    List<ClinicalCourseEntity>? subjects,
    String? subjectsError,
    ValueGetter<int?>? selectedSubjectId,
    ConfigStatus? configStatus,
    ValueGetter<SubjectConfigEntity?>? config,
    String? configError,
    List<ProcedureRequestEntity>? requests,
    List<String>? imagePaths,
    DateTime? focusedMonth,
    ValueGetter<DateTime?>? selectedDate,
    AvailableTimesStatus? timesStatus,
    List<String>? availableTimes,
    ValueGetter<String?>? selectedTime,
    WalkInSubmission? submission,
    String? submissionError,
  }) {
    return AddPatientState(
      currentStep: currentStep ?? this.currentStep,
      patientInfo: patientInfo ?? this.patientInfo,
      subjectsStatus: subjectsStatus ?? this.subjectsStatus,
      subjects: subjects ?? this.subjects,
      subjectsError: subjectsError,
      selectedSubjectId:
          selectedSubjectId != null ? selectedSubjectId() : this.selectedSubjectId,
      configStatus: configStatus ?? this.configStatus,
      config: config != null ? config() : this.config,
      configError: configError,
      requests: requests ?? this.requests,
      imagePaths: imagePaths ?? this.imagePaths,
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: selectedDate != null ? selectedDate() : this.selectedDate,
      timesStatus: timesStatus ?? this.timesStatus,
      availableTimes: availableTimes ?? this.availableTimes,
      selectedTime: selectedTime != null ? selectedTime() : this.selectedTime,
      submission: submission ?? this.submission,
      submissionError: submissionError,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        patientInfo,
        subjectsStatus,
        subjects,
        subjectsError,
        selectedSubjectId,
        configStatus,
        config,
        configError,
        requests,
        imagePaths,
        focusedMonth,
        selectedDate,
        timesStatus,
        availableTimes,
        selectedTime,
        submission,
        submissionError,
      ];
}
