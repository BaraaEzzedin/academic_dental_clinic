import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit({this.resendDurationSeconds = 60})
      : super(OtpState(secondsRemaining: resendDurationSeconds)) {
    _startCountdown();
  }

  final int resendDurationSeconds;
  Timer? _timer;

  void _startCountdown() {
    _timer?.cancel();
    emit(OtpState(secondsRemaining: resendDurationSeconds));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = state.secondsRemaining - 1;
      if (next <= 0) {
        timer.cancel();
        emit(const OtpState(secondsRemaining: 0));
      } else {
        emit(state.copyWith(secondsRemaining: next));
      }
    });
  }


  void resendCode() {
    if (!state.canResend) return;
    _startCountdown();
    // TODO(phase): re-request the code from the backend once integration is added.
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}