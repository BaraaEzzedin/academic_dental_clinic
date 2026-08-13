import 'package:equatable/equatable.dart';

class ClinicalCourseEntity extends Equatable {
  const ClinicalCourseEntity({
    required this.id,
    required this.name,
    this.shortName = '',
    this.requiresDentalChart = false,
    this.section = '',
    this.supervisor = '',
    this.description = '',
  });

  final int id;
  final String name;

  /// Compact label shown in the home subjects strip (e.g. "Restore 1").
  final String shortName;

  /// Whether cases for this subject use the tooth-based dental-chart workflow.
  final bool requiresDentalChart;

  final String section;
  final String supervisor;

  /// Kept for backward compatibility; the subjects API no longer sends it.
  final String description;

  /// Short label with a safe fallback to the full [name].
  String get displayName => shortName.trim().isNotEmpty ? shortName : name;

  @override
  List<Object?> get props => [
        id,
        name,
        shortName,
        requiresDentalChart,
        section,
        supervisor,
        description,
      ];
}