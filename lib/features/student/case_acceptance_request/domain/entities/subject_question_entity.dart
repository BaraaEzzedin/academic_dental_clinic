import 'package:equatable/equatable.dart';
import 'answer_option_entity.dart';
import 'question_type.dart';

class SubjectQuestionEntity extends Equatable {
  const SubjectQuestionEntity({
    required this.id,
    required this.question,
    required this.type,
    required this.required,
    required this.displayOrder,
    this.options = const [],
  });

  final int id;
  final String question;
  final QuestionType type;
  final bool required;
  final int displayOrder;

  /// Answer options for choice questions; empty for boolean/number.
  final List<AnswerOptionEntity> options;

  /// Options sorted by [AnswerOptionEntity.displayOrder]; never trust backend
  /// array order.
  List<AnswerOptionEntity> get orderedOptions {
    final list = [...options]
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return list;
  }

  @override
  List<Object?> get props => [
        id,
        question,
        type,
        required,
        displayOrder,
        options,
      ];
}