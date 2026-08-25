import 'package:equatable/equatable.dart';
import '../../../domain/entities/case_subject_entity.dart';
import '../../../domain/entities/open_case_entity.dart';

enum OpenCasesStatus { initial, loading, loaded, error }

class OpenCasesState extends Equatable {
  const OpenCasesState({
    this.status = OpenCasesStatus.initial,
    this.subjects = const [],
    this.cases = const [],
    this.selectedSubjectId,
    this.errorMessage,
  });

  final OpenCasesStatus status;
  final List<CaseSubjectEntity> subjects;
  final List<OpenCaseEntity> cases;
  final int? selectedSubjectId;
  final String? errorMessage;

  bool get isLoading => status == OpenCasesStatus.loading;
  bool get hasError => status == OpenCasesStatus.error;


  List<OpenCaseEntity> get filteredCases {
    if (selectedSubjectId == null ||
        selectedSubjectId == CaseSubjectEntity.allId) {
      return cases;
    }
    return cases
        .where((openCase) => openCase.subjectId == selectedSubjectId)
        .toList();
  }

  OpenCasesState copyWith({
    OpenCasesStatus? status,
    List<CaseSubjectEntity>? subjects,
    List<OpenCaseEntity>? cases,
    int? selectedSubjectId,
    String? errorMessage,
  }) {
    return OpenCasesState(
      status: status ?? this.status,
      subjects: subjects ?? this.subjects,
      cases: cases ?? this.cases,
      selectedSubjectId: selectedSubjectId ?? this.selectedSubjectId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, subjects, cases, selectedSubjectId, errorMessage];
}