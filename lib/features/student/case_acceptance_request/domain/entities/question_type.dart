enum QuestionType {
  boolean,
  number,
  singleChoice,
  multipleChoice,
  unknown;

  static QuestionType fromApi(String? raw) {
    switch (raw) {
      case 'boolean':
        return QuestionType.boolean;
      case 'number':
        return QuestionType.number;
      case 'single-choice':
        return QuestionType.singleChoice;
      case 'multiple-choice':
        return QuestionType.multipleChoice;
      default:
        return QuestionType.unknown;
    }
  }

  /// The string the backend expects back for this type.
  String get apiValue {
    switch (this) {
      case QuestionType.boolean:
        return 'boolean';
      case QuestionType.number:
        return 'number';
      case QuestionType.singleChoice:
        return 'single-choice';
      case QuestionType.multipleChoice:
        return 'multiple-choice';
      case QuestionType.unknown:
        return 'unknown';
    }
  }

  bool get isChoice =>
      this == QuestionType.singleChoice || this == QuestionType.multipleChoice;
}