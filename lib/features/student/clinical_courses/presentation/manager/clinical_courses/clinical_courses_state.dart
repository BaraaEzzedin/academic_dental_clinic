import 'package:equatable/equatable.dart';
import '../../../domain/entities/clinical_course_entity.dart';

enum ClinicalCoursesStatus { initial, loading, loaded, error }

class ClinicalCoursesState extends Equatable {
  const ClinicalCoursesState({
    this.status = ClinicalCoursesStatus.initial,
    this.courses = const [],
    this.errorMessage,
  });

  final ClinicalCoursesStatus status;
  final List<ClinicalCourseEntity> courses;
  final String? errorMessage;

  bool get isLoading => status == ClinicalCoursesStatus.loading;
  bool get hasError => status == ClinicalCoursesStatus.error;
  bool get isEmpty =>
      status == ClinicalCoursesStatus.loaded && courses.isEmpty;
  bool get hasCourses =>
      status == ClinicalCoursesStatus.loaded && courses.isNotEmpty;

  ClinicalCoursesState copyWith({
    ClinicalCoursesStatus? status,
    List<ClinicalCourseEntity>? courses,
    String? errorMessage,
  }) {
    return ClinicalCoursesState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, courses, errorMessage];
}