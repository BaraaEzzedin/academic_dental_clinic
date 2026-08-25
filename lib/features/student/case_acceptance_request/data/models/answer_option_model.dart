import '../../domain/entities/answer_option_entity.dart';

class AnswerOptionModel extends AnswerOptionEntity {
  const AnswerOptionModel({
    required super.id,
    required super.text,
    required super.displayOrder,
  });

  factory AnswerOptionModel.fromJson(Map<String, dynamic> json) {
    return AnswerOptionModel(
      id: (json['optionId'] as num).toInt(),
      text: json['optionText'] as String? ?? '',
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'optionId': id,
      'optionText': text,
      'displayOrder': displayOrder,
    };
  }
}