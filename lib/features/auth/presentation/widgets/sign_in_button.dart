import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_primary_button.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: 'Sign In',
      trailingIcon: Icons.login,
      onPressed: onPressed,
    );
  }
}