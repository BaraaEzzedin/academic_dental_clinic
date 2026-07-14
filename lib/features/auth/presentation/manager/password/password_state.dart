import 'package:equatable/equatable.dart';

class PasswordState extends Equatable {
  const PasswordState({this.obscurePassword = true});

  final bool obscurePassword;

  PasswordState copyWith({bool? obscurePassword}) {
    return PasswordState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  List<Object?> get props => [obscurePassword];
}