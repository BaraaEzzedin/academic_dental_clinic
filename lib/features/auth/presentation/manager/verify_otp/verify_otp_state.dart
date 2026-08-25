import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

abstract class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object?> get props => [];
}

class VerifyOtpInitial extends VerifyOtpState {
  const VerifyOtpInitial();
}

class VerifyOtpLoading extends VerifyOtpState {
  const VerifyOtpLoading();
}

class VerifyOtpSuccess extends VerifyOtpState {
  const VerifyOtpSuccess(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

class VerifyOtpFailure extends VerifyOtpState {
  const VerifyOtpFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}