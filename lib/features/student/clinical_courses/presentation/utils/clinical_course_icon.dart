import 'package:flutter/material.dart';
import '../../domain/entities/clinical_course_entity.dart';

/// Maps a clinical course to a representative, dental-/clinical-themed icon.
///
/// This is a presentation concern: the icon is derived from the course name so
/// mock and real data both render sensibly.
///
/// TODO(backend): once courses carry a stable `category`/`type`, key this map
/// off that instead of the display name to stay resilient to renaming.
IconData clinicalCourseIcon(ClinicalCourseEntity course) {
  switch (course.name.trim().toLowerCase()) {
    case 'endodontics':
      return Icons.healing_rounded;
    case 'prosthodontics':
      return Icons.auto_awesome_rounded;
    case 'oral surgery':
      return Icons.medical_services_rounded;
    case 'periodontics':
      return Icons.spa_rounded;
    case 'pediatric dentistry':
      return Icons.child_care_rounded;
    default:
      return Icons.medical_information_rounded;
  }
}