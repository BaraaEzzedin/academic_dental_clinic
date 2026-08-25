import 'package:equatable/equatable.dart';

class AvailableProcedureEntity extends Equatable {
  const AvailableProcedureEntity({
    required this.id,
    required this.name,
    this.requiredCount,
    this.description,
  });

  final int id;
  final String name;

  /// Number of cases the student must complete for this procedure.
  final int? requiredCount;
  final String? description;

  bool get hasDescription =>
      description != null && description!.trim().isNotEmpty;

  @override
  List<Object?> get props => [id, name, requiredCount, description];
}