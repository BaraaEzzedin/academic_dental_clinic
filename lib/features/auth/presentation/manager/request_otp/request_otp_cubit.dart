import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/request_otp_use_case.dart';
import 'request_otp_state.dart';

class RequestOtpCubit extends Cubit<RequestOtpState> {
  RequestOtpCubit(this._requestOtpUseCase) : super(const RequestOtpInitial());

  final RequestOtpUseCase _requestOtpUseCase;

  Future<void> requestOtp({required String phone}) async {
    emit(const RequestOtpLoading());
    final result = await _requestOtpUseCase(RequestOtpParams(phone: phone));
    result.fold(
      (failure) => emit(RequestOtpFailure(failure.message)),
      (_) => emit(RequestOtpSuccess(phone)),
    );
  }
}