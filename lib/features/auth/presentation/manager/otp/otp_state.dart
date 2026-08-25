import 'package:equatable/equatable.dart';

class OtpState extends Equatable {
  const OtpState({required this.secondsRemaining});

  final int secondsRemaining;

  bool get canResend => secondsRemaining <= 0;

  OtpState copyWith({int? secondsRemaining}) {
    return OtpState(
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
    );
  }

  @override
  List<Object?> get props => [secondsRemaining];
}