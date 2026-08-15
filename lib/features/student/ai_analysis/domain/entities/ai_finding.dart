import 'package:equatable/equatable.dart';

class AiFinding extends Equatable {
  const AiFinding({
    required this.condition,
    required this.confidence,
    required this.region,
    required this.color,
  });

  /// e.g. "impacted tooth", "Crown", "Filling".
  final String condition;

  /// Model confidence in the range 0.0–1.0.
  final double confidence;

  /// e.g. "lower right molar".
  final String region;

  /// Colour name returned by the model (e.g. "green", "white", "blue"),
  /// used to tint the finding's marker.
  final String color;

  int get confidencePercent => (confidence * 100).round();

  @override
  List<Object?> get props => [condition, confidence, region, color];
}