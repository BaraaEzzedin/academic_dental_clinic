import '../../domain/entities/case_media_entity.dart';

class CaseMediaModel extends CaseMediaEntity {
  const CaseMediaModel({
    required super.url,
    required super.description,
    super.takenAt,
  });

  factory CaseMediaModel.fromJson(Map<String, dynamic> json) {
    return CaseMediaModel(
      url: json['url'] as String? ?? '',
      description: json['description'] as String? ?? '',
      takenAt: DateTime.tryParse(json['takenAt'] as String? ?? ''),
    );
  }
}
