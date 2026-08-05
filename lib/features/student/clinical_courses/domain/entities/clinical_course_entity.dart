import 'package:equatable/equatable.dart';

/// A clinical course the student is enrolled in for the current semester.
///
/// This is a lightweight entity for the Home section. In a future iteration a
/// course will expand into a full Course Details feature (progress, completed
/// and required procedures, related cases, supervisor…), so keep this shape
/// aligned with what the backend course resource will return.
class ClinicalCourseEntity extends Equatable {
  const ClinicalCourseEntity({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}