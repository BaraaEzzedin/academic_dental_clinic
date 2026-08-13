import 'package:equatable/equatable.dart';

/// A single chosen option of a choice question, e.g. `{ id: 5, label: "Heat" }`.
/// Only the [label] is ever shown — never the [id].
class SelectedOptionEntity extends Equatable {
  const SelectedOptionEntity({required this.id, required this.label});

  final int id;
  final String label;

  @override
  List<Object?> get props => [id, label];
}
