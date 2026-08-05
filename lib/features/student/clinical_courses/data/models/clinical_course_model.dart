import '../../domain/entities/clinical_course_entity.dart';

class ClinicalCourseModel extends ClinicalCourseEntity {
  const ClinicalCourseModel({
    required super.id,
    required super.name,
    required super.description,
  });

  factory ClinicalCourseModel.fromJson(Map<String, dynamic> json) {
    return ClinicalCourseModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}