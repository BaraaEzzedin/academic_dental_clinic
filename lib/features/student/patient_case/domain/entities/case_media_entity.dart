import 'package:equatable/equatable.dart';

/// A diagnostic media item from `caseMedia`.
class CaseMediaEntity extends Equatable {
  const CaseMediaEntity({
    required this.url,
    required this.description,
    this.takenAt,
  });

  final String url;
  final String description;
  final DateTime? takenAt;

  @override
  List<Object?> get props => [url, description, takenAt];
}
