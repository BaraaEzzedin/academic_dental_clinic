import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_text_button.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AppTextButton(
        label: 'Forgot Password?',
        onPressed: onPressed,
      ),
    );
  }
}