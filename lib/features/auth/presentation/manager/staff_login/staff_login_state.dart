import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

abstract class StaffLoginState extends Equatable {
  const StaffLoginState();

  @override
  List<Object?> get props => [];
}

class StaffLoginInitial extends StaffLoginState {
  const StaffLoginInitial();
}

class StaffLoginLoading extends StaffLoginState {
  const StaffLoginLoading();
}

class StaffLoginSuccess extends StaffLoginState {
  const StaffLoginSuccess(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

class StaffLoginFailure extends StaffLoginState {
  const StaffLoginFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}