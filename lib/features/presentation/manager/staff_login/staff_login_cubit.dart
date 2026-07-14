import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/staff_login_use_case.dart';
import 'staff_login_state.dart';

class StaffLoginCubit extends Cubit<StaffLoginState> {
  StaffLoginCubit(this._loginUseCase) : super(const StaffLoginInitial());

  final StaffLoginUseCase _loginUseCase;

  Future<void> login({
    required String universityId,
    required String password,
  }) async {
    emit(const StaffLoginLoading());
    final result = await _loginUseCase(
      LoginParams(universityId: universityId, password: password),
    );
    result.fold(
      (failure) => emit(StaffLoginFailure(failure.message)),
      (user) => emit(StaffLoginSuccess(user)),
    );
  }
}