import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/staff_login_use_case.dart';
import 'staff_login_state.dart';

class StaffLoginCubit extends Cubit<StaffLoginState> {
  StaffLoginCubit(this._loginUseCase) : super(const StaffLoginInitial());

  final StaffLoginUseCase _loginUseCase;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const StaffLoginLoading());
    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(StaffLoginFailure(failure.message)),
      (user) => emit(StaffLoginSuccess(user)),
    );
  }
}