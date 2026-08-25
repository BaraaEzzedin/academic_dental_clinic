import 'package:equatable/equatable.dart';

/// A selectable option for `single-choice` / `multiple-choice` questions.
class AnswerOptionEntity extends Equatable {
  const AnswerOptionEntity({
    required this.id,
    required this.text,
    required this.displayOrder,
  });

  final int id;
  final String text;
  final int displayOrder;

  @override
  List<Object?> get props => [id, text, displayOrder];
}