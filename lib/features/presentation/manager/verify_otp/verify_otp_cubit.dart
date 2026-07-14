import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/verify_otp_use_case.dart';
import 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit(this._verifyOtpUseCase) : super(const VerifyOtpInitial());

  final VerifyOtpUseCase _verifyOtpUseCase;

  Future<void> verifyOtp({
    required String phone,
    required String code,
  }) async {
    emit(const VerifyOtpLoading());
    final result = await _verifyOtpUseCase(
      VerifyOtpParams(phone: phone, code: code),
    );
    result.fold(
      (failure) => emit(VerifyOtpFailure(failure.message)),
      (user) => emit(VerifyOtpSuccess(user)),
    );
  }
}