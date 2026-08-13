import '../../domain/entities/procedure_answer_entity.dart';
import 'selected_option_model.dart';

class ProcedureAnswerModel extends ProcedureAnswerEntity {
  const ProcedureAnswerModel({
    required super.question,
    super.rawAnswer,
    super.selectedOptions,
  });

  factory ProcedureAnswerModel.fromJson(Map<String, dynamic> json) {
    final options = json['selectedOptions'] as List<dynamic>? ?? const [];
    final rawAnswer = json['answer'];
    return ProcedureAnswerModel(
      question: json['question'] as String? ?? '',
      // `answer` may arrive as String, num or bool — normalise to a String.
      rawAnswer: rawAnswer?.toString(),
      selectedOptions: options
          .whereType<Map<String, dynamic>>()
          .map(SelectedOptionModel.fromJson)
          .toList(),
    );
  }
}
