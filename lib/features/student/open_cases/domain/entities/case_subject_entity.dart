import 'package:equatable/equatable.dart';

class CaseSubjectEntity extends Equatable {
  const CaseSubjectEntity({
    required this.id,
    required this.name,
  });

  static const int allId = -1;

  static const CaseSubjectEntity all =
      CaseSubjectEntity(id: allId, name: 'All');

  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}