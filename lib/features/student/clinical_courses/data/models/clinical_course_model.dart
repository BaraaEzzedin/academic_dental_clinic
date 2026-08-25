import '../../domain/entities/clinical_course_entity.dart';

class ClinicalCourseModel extends ClinicalCourseEntity {
  const ClinicalCourseModel({
    required super.id,
    required super.name,
    super.shortName,
    super.requiresDentalChart,
    super.section,
    super.supervisor,
    super.description,
  });

  factory ClinicalCourseModel.fromJson(Map<String, dynamic> json) {
    return ClinicalCourseModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      shortName: json['shortName'] as String? ?? '',
      requiresDentalChart: json['requiresDentalChart'] as bool? ?? false,
      section: json['section'] as String? ?? '',
      supervisor: json['supervisor'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}
