import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/get_clinical_courses_use_case.dart';
import 'clinical_courses_state.dart';

class ClinicalCoursesCubit extends Cubit<ClinicalCoursesState> {
  ClinicalCoursesCubit(this._getClinicalCourses)
      : super(const ClinicalCoursesState());

  final GetClinicalCoursesUseCase _getClinicalCourses;

  Future<void> loadCourses() async {
    emit(state.copyWith(status: ClinicalCoursesStatus.loading));
    final result = await _getClinicalCourses();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ClinicalCoursesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (courses) => emit(
        state.copyWith(
          status: ClinicalCoursesStatus.loaded,
          courses: courses,
        ),
      ),
    );
  }
}