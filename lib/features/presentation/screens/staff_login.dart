import 'package:academic_dental_clinic/core/constants/app_colors.dart';
import 'package:academic_dental_clinic/features/presentation/widgets/logo_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../manager/password cubit/password_cubit.dart';
import '../manager/password cubit/password_state.dart';
import '../widgets/login_form_card.dart';


class StaffLogin extends StatefulWidget {
  const StaffLogin({super.key});

  @override
  State<StaffLogin> createState() => _StaffLoginState();
}

class _StaffLoginState extends State<StaffLogin> {
  final TextEditingController _universityIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _universityIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  void _onSignIn() {}
  void _onForgotPassword() {}
  void _onContactAdmin() {}

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PasswordCubit>(
      create: (_) => PasswordCubit(),
      child: Scaffold(backgroundColor: AppColors.scaffoldBackground,
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenHorizontalPadding,
              vertical: AppDimensions.xxl,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: AppDimensions.xl,
                  ),
                  const LogoSection(),
                  const SizedBox(height: AppDimensions.xl),
                  Text("Welcome Back" , style:GoogleFonts.caveat(
           fontSize: 38,
           fontWeight: FontWeight.bold,
           color: Color(0xff024D65)
                       )),
                  SizedBox(height: 5,),
                  Text("Sign in to access your academic and clinical dashboard " , textAlign: TextAlign.center, style:GoogleFonts.manrope(
             fontSize: 18,
             fontWeight: FontWeight.normal,
             color: Color(0xff024D65)
                       )),
                  const SizedBox(height: AppDimensions.xxl),
                  BlocBuilder<PasswordCubit, PasswordState>(
                    builder: (context, state) {
                      final cubit = context.read<PasswordCubit>();
                      return LoginFormCard(
                        universityIdController: _universityIdController,
                        passwordController: _passwordController,
                        obscurePassword: state.obscurePassword,
                        onTogglePassword: cubit.togglePasswordVisibility,
                        onForgotPassword: _onForgotPassword,
                        onSignIn: _onSignIn,
                        onContactAdmin: _onContactAdmin,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
     );
  }
}
