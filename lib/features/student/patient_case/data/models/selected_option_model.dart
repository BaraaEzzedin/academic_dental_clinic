import '../../domain/entities/selected_option_entity.dart';

class SelectedOptionModel extends SelectedOptionEntity {
  const SelectedOptionModel({required super.id, required super.label});

  factory SelectedOptionModel.fromJson(Map<String, dynamic> json) {
    return SelectedOptionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      label: json['label'] as String? ?? '',
    );
  }
}
