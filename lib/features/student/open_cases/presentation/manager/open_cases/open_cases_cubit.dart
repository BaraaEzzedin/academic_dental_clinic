import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/case_subject_entity.dart';
import '../../mock/mock_open_cases.dart';
import 'open_cases_state.dart';

class OpenCasesCubit extends Cubit<OpenCasesState> {
  OpenCasesCubit() : super(const OpenCasesState());

  /// TODO(backend): replace the mock data below with a `GetOpenCasesUseCase`
  /// call once the API is ready. The rest of the flow (state shape, selection,
  /// widgets) stays the same.
  Future<void> loadCases() async {
    emit(state.copyWith(status: OpenCasesStatus.loading));

    // Simulated network latency so the loading state is visible with mocks.
    await Future<void>.delayed(const Duration(seconds: 5));

    const cases = mockOpenCases;

    final subjects = [CaseSubjectEntity.all, ...mockCaseSubjects];

    emit(
      state.copyWith(
        status: OpenCasesStatus.loaded,
        subjects: subjects,
        cases: cases,
        selectedSubjectId: CaseSubjectEntity.allId,
      ),
    );
  }

  void selectSubject(int subjectId) {
    if (subjectId == state.selectedSubjectId) return;
    emit(state.copyWith(selectedSubjectId: subjectId));
  }
}