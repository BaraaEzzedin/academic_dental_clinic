import 'package:academic_dental_clinic/core/constants/app_colors.dart';
import 'package:academic_dental_clinic/core/service_locator/auth_service.dart';
import 'package:academic_dental_clinic/core/theme/app_text_style.dart';
import 'package:academic_dental_clinic/features/presentation/widgets/logo_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/usecases/staff_login_use_case.dart';
import '../manager/password/password_cubit.dart';
import '../manager/password/password_state.dart';
import '../manager/staff_login/staff_login_cubit.dart';
import '../manager/staff_login/staff_login_state.dart';
import '../widgets/login_form_card.dart';


class StaffLogin extends StatefulWidget {
  const StaffLogin({super.key});

  @override
  State<StaffLogin> createState() => _StaffLoginState();
}

class _StaffLoginState extends State<StaffLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  void _onSignIn(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    context.read<StaffLoginCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _onForgotPassword() {}
  void _onContactAdmin() {}

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PasswordCubit>(
          create: (_) => PasswordCubit(),
        ),
        BlocProvider<StaffLoginCubit>(
          create: (_) => StaffLoginCubit(sl<StaffLoginUseCase>()),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: BlocConsumer<StaffLoginCubit, StaffLoginState>(
            listener: (context, state) {
              if (state is StaffLoginFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is StaffLoginSuccess) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('Welcome, ${state.user.fullName}')),
                  );
                // TODO(phase): navigate to the staff dashboard once it exists.
              }
            },
            builder: (context, loginState) {
              final isLoading = loginState is StaffLoginLoading;
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontalPadding,
                      vertical: AppDimensions.xxl,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: AppDimensions.lg,
                        ),
                        const LogoSection(),
                        const SizedBox(height: AppDimensions.xl),
                        Text("Welcome Back", style: AppTextStyles.welcome),
                        SizedBox(height: 5,),
                        Text(
                          "Sign in to access your academic and clinical dashboard ",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.loginText,
                        ),
                        const SizedBox(height: AppDimensions.xxl),
                        BlocBuilder<PasswordCubit, PasswordState>(
                          builder: (context, state) {
                            final cubit = context.read<PasswordCubit>();
                            return LoginFormCard(
                              formKey: _formKey,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              obscurePassword: state.obscurePassword,
                              onTogglePassword: cubit.togglePasswordVisibility,
                              onForgotPassword: _onForgotPassword,
                              onSignIn:
                                  isLoading ? () {} : () => _onSignIn(context),
                              onContactAdmin: _onContactAdmin,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    const Positioned.fill(
                      child: ColoredBox(
                        color: Colors.black26,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}