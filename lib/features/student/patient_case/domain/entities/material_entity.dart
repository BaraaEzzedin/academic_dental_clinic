import 'package:equatable/equatable.dart';

/// A material a student can select when completing a session. Only [name] is
/// shown; [id] is sent back as `materialId`.
class MaterialEntity extends Equatable {
  const MaterialEntity({required this.id, required this.name});

  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
