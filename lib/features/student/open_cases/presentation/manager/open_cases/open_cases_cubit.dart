import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../clinical_courses/domain/use_cases/get_clinical_courses_use_case.dart';
import '../../../domain/entities/case_subject_entity.dart';
import '../../../domain/use_cases/get_open_cases_use_case.dart';
import 'open_cases_state.dart';

class OpenCasesCubit extends Cubit<OpenCasesState> {
  OpenCasesCubit(this._getOpenCases, this._getSubjects)
      : super(const OpenCasesState());

  final GetOpenCasesUseCase _getOpenCases;
  final GetClinicalCoursesUseCase _getSubjects;

  Future<void> loadCases() async {
    emit(state.copyWith(status: OpenCasesStatus.loading));

    final subjectsResult = await _getSubjects();
    final casesResult = await _getOpenCases();

    subjectsResult.fold(
      (failure) => emit(
        state.copyWith(
          status: OpenCasesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (courses) => casesResult.fold(
        (failure) => emit(
          state.copyWith(
            status: OpenCasesStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (cases) {
          final subjects = [
            CaseSubjectEntity.all,
            ...courses.map(
              (course) => CaseSubjectEntity(id: course.id, name: course.name),
            ),
          ];

          emit(
            state.copyWith(
              status: OpenCasesStatus.loaded,
              subjects: subjects,
              cases: cases,
              selectedSubjectId: CaseSubjectEntity.allId,
            ),
          );
        },
      ),
    );
  }

  void selectSubject(int subjectId) {
    if (subjectId == state.selectedSubjectId) return;
    emit(state.copyWith(selectedSubjectId: subjectId));
  }
}