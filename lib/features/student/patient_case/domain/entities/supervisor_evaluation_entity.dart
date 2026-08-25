import 'package:equatable/equatable.dart';

/// The supervisor's final evaluation of a case, from `evaluation`.
///
/// The whole object is absent (`null`) until a supervisor has evaluated the
/// case, so the screen shows the evaluation section only when this is present.
class SupervisorEvaluationEntity extends Equatable {
  const SupervisorEvaluationEntity({
    required this.grade,
    required this.comment,
    this.createdAt,
  });

  /// The awarded grade/score, e.g. "A-" or "95 / 100".
  final String grade;

  /// The supervisor's written feedback.
  final String comment;

  /// When the evaluation was recorded.
  final DateTime? createdAt;

  @override
  List<Object?> get props => [grade, comment, createdAt];
}