// import 'package:academic_dental_clinic/features/presentation/widgets/password_field.dart';
// import 'package:academic_dental_clinic/features/presentation/widgets/sign_in_button.dart';
// import 'package:academic_dental_clinic/features/presentation/widgets/university_id_field.dart';
// import 'package:flutter/material.dart';
//
// class LoginFormCard extends StatefulWidget {
//   const LoginFormCard({super.key});
//
//   @override
//   State<LoginFormCard> createState() => _LoginFormCardState();
// }
//
// class _LoginFormCardState extends State<LoginFormCard> {
//
//   final formKey = GlobalKey<FormState>();
//
//   final universityController =
//   TextEditingController();
//
//   final passwordController =
//   TextEditingController();
//
//   final bool obscurePassword = true;
//   final VoidCallback onTogglePassword;
//   final VoidCallback onForgotPassword;
//   final VoidCallback onSignIn;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(22),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Color(0xFFC2E8FF),width: 2),
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 15,
//             color: Colors.black.withOpacity(.12),
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//         child: Form(
//           key: formKey,
//           child: Column(
//             children: [
//
//
//           const SizedBox(height: 20),
//
//
//
//           const SizedBox(height: 20),
//           SignInButton(onPressed:)
//
//        ] ),));
//   }
// }

import 'package:academic_dental_clinic/features/presentation/widgets/forgot_password_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import 'password_field.dart';
import 'sign_in_button.dart';
import 'university_id_field.dart';

class LoginFormCard extends StatelessWidget {
  const LoginFormCard({
    super.key,
    required this.universityIdController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onForgotPassword,
    required this.onSignIn,
    required this.onContactAdmin,
  });

  final TextEditingController universityIdController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignIn;
  final VoidCallback onContactAdmin;

  @override
  Widget build(BuildContext context) {
    return Container(
       padding: EdgeInsets.all(22),
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(16),
         border: Border.all(color: Color(0xFFC2E8FF),width: 2),
         boxShadow: [
           BoxShadow(
             blurRadius: 15,
             color: Colors.black.withOpacity(.12),
            offset: const Offset(0, 6),
           ),
         ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UniversityIdField(controller: universityIdController),
          const SizedBox(height: AppDimensions.xl),
          PasswordField(
            controller: passwordController,
            obscureText: obscurePassword,
            onToggleObscure: onTogglePassword,
          ),
          const SizedBox(height: AppDimensions.md),
          ForgotPasswordButton(onPressed: onForgotPassword),
          const SizedBox(height: AppDimensions.xl),
          SignInButton(onPressed: onSignIn),
          const SizedBox(height: AppDimensions.xl),
        ],
      ),
    );
  }
}
