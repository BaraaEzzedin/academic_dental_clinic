import 'package:academic_dental_clinic/features/auth/presentation/manager/password/password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordCubit extends Cubit<PasswordState> {
  PasswordCubit() : super(const PasswordState());

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }
}