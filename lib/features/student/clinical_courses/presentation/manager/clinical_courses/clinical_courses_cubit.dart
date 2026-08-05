import 'package:flutter_bloc/flutter_bloc.dart';
import '../../mock/mock_clinical_courses.dart';
import 'clinical_courses_state.dart';

class ClinicalCoursesCubit extends Cubit<ClinicalCoursesState> {
  ClinicalCoursesCubit() : super(const ClinicalCoursesState());

  /// TODO(backend): replace the mock data below with a
  /// `GetEnrolledCoursesUseCase` call once the API is ready. The state shape
  /// and the widgets stay the same — only this method changes.
  Future<void> loadCourses() async {
    emit(state.copyWith(status: ClinicalCoursesStatus.loading));

    // Simulated network latency so the loading shimmer is visible with mocks.
    await Future<void>.delayed(const Duration(seconds: 2));

    emit(
      state.copyWith(
        status: ClinicalCoursesStatus.loaded,
        courses: mockClinicalCourses,
      ),
    );
  }
}