import 'package:equatable/equatable.dart';

class AvailableProcedureEntity extends Equatable {
  const AvailableProcedureEntity({
    required this.id,
    required this.name,
    this.description,
  });

  final int id;
  final String name;
  final String? description;

  @override
  List<Object?> get props => [id, name, description];
}