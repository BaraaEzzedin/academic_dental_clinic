import 'package:equatable/equatable.dart';

abstract class RequestOtpState extends Equatable {
  const RequestOtpState();

  @override
  List<Object?> get props => [];
}

class RequestOtpInitial extends RequestOtpState {
  const RequestOtpInitial();
}

class RequestOtpLoading extends RequestOtpState {
  const RequestOtpLoading();
}

class RequestOtpSuccess extends RequestOtpState {
  const RequestOtpSuccess(this.phone);

  final String phone;

  @override
  List<Object?> get props => [phone];
}

class RequestOtpFailure extends RequestOtpState {
  const RequestOtpFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}