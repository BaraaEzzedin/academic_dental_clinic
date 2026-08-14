import '../../domain/entities/material_entity.dart';

class MaterialModel extends MaterialEntity {
  const MaterialModel({required super.id, required super.name});

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    // Tolerant of either `materialId`/`id` and `materialName`/`name` keys.
    final id = (json['materialId'] as num?)?.toInt() ??
        (json['id'] as num?)?.toInt() ??
        0;
    return MaterialModel(
      id: id,
      name: json['materialName'] as String? ?? json['name'] as String? ?? '',
    );
  }
}
