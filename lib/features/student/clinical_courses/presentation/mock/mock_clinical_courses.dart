import '../../domain/entities/clinical_course_entity.dart';

/// Mock enrollment: 5 clinical courses for the current semester.
///
/// TODO(backend): replace with the real "enrolled courses" endpoint. The
/// widgets consume [ClinicalCourseEntity] only, so nothing downstream changes.
const List<ClinicalCourseEntity> mockClinicalCourses = [
  ClinicalCourseEntity(id: 1, name: 'Extraction 1'),
  ClinicalCourseEntity(id: 2, name: 'Removable 2'),
  ClinicalCourseEntity(id: 3, name: 'Operative 3'),
  ClinicalCourseEntity(id: 4, name: 'Oral Med 2'),
  ClinicalCourseEntity(id: 5, name: 'Pediatric 1'),
];